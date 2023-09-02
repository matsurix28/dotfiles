Set Fso = CreateObject( "Scripting.FileSystemObject" )
Set objShell = CreateObject("Shell.Application")

file = WScript.Arguments(0)
strPath = Fso.GetParentFolderName(file)
strFile = Fso.GetFileName(file)
msg = "Installing " + strFile

Set objFolder = objShell.NameSpace(strPath)
Set objFile = objFolder.ParseName(strFile)

Set obj = objFile.Verbs
Set fso = Nothing

For Each objItem In obj
    if objItem.Name = "すべてのユーザーに対してインストール(&A)" then
        objItem.DoIt()
        Exit For
    end if
Next