#tag Class
Protected Class JSONData
Inherits JSONItem
	#tag ViewBehavior
		#tag ViewProperty
			Name="Compact"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="JSONItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DecimalFormat"
			Group="Behavior"
			InitialValue="-0.0##############"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="JSONItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IndentSpacing"
			Group="Behavior"
			InitialValue="2"
			Type="Integer"
			InheritedFrom="JSONItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="ToString"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="JSONItem"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
