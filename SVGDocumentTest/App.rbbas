#tag Class
Protected Class App
Inherits Application
	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Borrar", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"&Borrar"
		#Tag Instance, Platform = Mac Classic, Language = Default, Definition  = \"&Borrar"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"Salir", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Salir"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = -, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Mac Classic, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


End Class
#tag EndClass
