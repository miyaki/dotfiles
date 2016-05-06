"""
Automate loading of F-Script Anywhere into any app.
By Daniel Jalkut - @danielpunkass - http://indiestack.com/
Revision 0.2 by Marco Fabbri - @mrfabbri - mrfabbri@gmail.com

To set up:

0. Make sure you have FScript.framework installed in /Library/Frameworks (http://www.fscript.org)
1. Copy this script to ~/.lldb/fsa.py
2. Add the following to your ~/.lldbinit file:

command script import ~/.lldb/fsa.py

To use:

1.  Attach to a process e.g. by "lldb -n TextEdit"
2.  Type "fsa" to load an initialize F-Script Anywhere in the context of the app.
2b. Type "fsac" to show F-Script Console (optional, useful in case the app does
    not have a menu bar).
3.  Type "c" to continue execution of the target app.

"""

def handleCommands(debugger, cmds):
    for cmd in filter(bool, map(str.strip, cmds.split('\n'))):
        debugger.HandleCommand(cmd)

def someFun(somethingFunny):
    print somethingFunny

def loadFSA(debugger, args, result, internal_dict):
    handleCommands(debugger, '''
        expr (void) [[NSBundle bundleWithPath:@"/Library/Frameworks/FScript.framework"] load]
        expr FScriptMenuItem *$menuItem = [FScriptMenuItem alloc]
        expr (void) [$menuItem init]
        expr (void) [[[NSApplication sharedApplication] mainMenu] addItem:$menuItem]
    ''')

def showConsole(debugger, args, result, internal_dict):
    handleCommands(debugger, '''
        expr (void) [$menuItem openObjectBrowser:nil]
        expr (void) [$menuItem showConsole:nil]
    ''')

def __lldb_init_module(debugger, dict):
    handleCommands(debugger, '''
        command script add -f fsa.loadFSA fsa
        command script add -f fsa.showConsole fsac
    ''')
