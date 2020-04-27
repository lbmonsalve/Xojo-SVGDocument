#tag Interface
Protected Interface ISVGShape
	#tag Method, Flags = &h0
		Function Attribute(name As String) As String
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AttributeCount() As Integer
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasAttribute(name As String) As Boolean
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Object2D() As Object2D
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointLists() As SVGPointList()
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Readme
		
		Used for handle xml node attributes. I choose interface because I want the data immutable
	#tag EndNote


	#tag ViewBehavior
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
	#tag EndViewBehavior
End Interface
#tag EndInterface
