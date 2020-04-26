#tag Class
Protected Class SVGShape
Implements ISVGShape
	#tag Method, Flags = &h0
		Function Attribute(name As String) As String
		  // Parte de la interfaz ISVGShape.
		  
		  If Not mData.HasKey(name) Then
		    Dim exc As New KeyNotFoundException
		    exc.Message= "Attribute """+ name+ """ not found"
		    Raise exc
		  End If
		  
		  Return mData.Value(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function AttributeCount() As Integer
		  // Parte de la interfaz ISVGShape.
		  
		  Return mData.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(obj As Object2D, node As XmlElement)
		  mObj2D= obj
		  
		  mData= New Dictionary
		  
		  For i As Integer= 0 To node.AttributeCount- 1
		    mData.Value(node.GetAttributeNode(i).Name)= node.GetAttributeNode(i).Value
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasAttribute(name As String) As Boolean
		  // Parte de la interfaz ISVGShape.
		  
		  Return mData.HasKey(name)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Object2D() As Object2D
		  Return mObj2D
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mData As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mObj2D As Object2D
	#tag EndProperty


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
End Class
#tag EndClass
