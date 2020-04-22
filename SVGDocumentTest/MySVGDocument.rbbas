#tag Class
Protected Class MySVGDocument
Inherits SVGDocument
	#tag Event
		Sub Object2DAdded(obj As Object2D, node As XmlElement)
		  // look for metadata, in this case just the title= name of country
		  
		  Dim nodeTitle As String
		  Try // look for title attribute
		    #pragma BreakOnExceptions Off
		    nodeTitle= node.GetAttributeNode("title").Value
		    #pragma BreakOnExceptions Default
		  Catch exc As RuntimeException
		    Return
		  End Try
		  
		  Dim p As New Pair(nodeTitle, obj)
		  mData.Append p // i need just the country name and the group2D
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Function GetData() As Pair()
		  Dim ret() As Pair
		  
		  For Each p As Pair In mData
		    ret.Append New Pair(p.Left, p.Right)
		  Next
		  
		  Return ret // returns a "copy" of the array, not the array reference
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mData() As Pair
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InheritedFrom="XMLDocument"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InheritedFrom="XMLDocument"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="XMLDocument"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="XMLDocument"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InheritedFrom="XMLDocument"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
