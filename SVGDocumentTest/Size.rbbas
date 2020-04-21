#tag Class
Protected Class Size
	#tag Method, Flags = &h0
		Function Clone() As Size
		  Return New Size(Self.Width, Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(width As Single, height As Single)
		  Self.Width= width
		  Self.Height= height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As Size) As Size
		  Return New Size(Self.Width+ rhs.Width, Self.Height+ rhs.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As String) As String
		  Return ToString+ rhs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_AddRight(lhs As String) As String
		  Return lhs+ ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(rhs As Size) As Integer
		  Dim a, b As Single
		  a= Self.Area
		  b= rhs.Area
		  
		  If a> b Then Return 1
		  If a< b Then Return -1
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(rhs As String)
		  Dim json As New JSONData
		  
		  Try
		    #pragma BreakOnExceptions False
		    json.Load rhs
		    #pragma BreakOnExceptions Default
		    
		    If json.HasName("Width") Then Self.Width= json.Value("Width").SingleValue
		    If json.HasName("Height") Then Self.Height= json.Value("Height").SingleValue
		  Catch e As JSONException
		    System.DebugLog CurrentMethodName+ " json.Load rhs (error): "+ e.Message
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Negate() As Size
		  Return New Size(-1* Self.Width, -1* Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(rhs As Size) As Size
		  Return New Size(Self.Width- rhs.Width, Self.Height- rhs.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSONData(compact As Boolean = True) As JSONData
		  Dim ret As New JSONData
		  ret.Compact= compact
		  
		  ret.Value("Width")= Self.Width
		  ret.Value("Height")= Self.Height
		  
		  Return ret
		  
		Exception e As JSONException
		  
		  System.DebugLog CurrentMethodName+ " JSONError:"+ e.Message
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(compact As Boolean = True) As String
		  'Return "{""Width"":"+ NumberToString(Self.Width)+ ",""Height"":"+ NumberToString(Self.Height)+ "}"
		  
		  Return ToJSONData(compact).ToString
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Width* Self.Height
			End Get
		#tag EndGetter
		Area As Single
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Height As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		Width As Single
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Area"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Group="Behavior"
			Type="Single"
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
			Name="Width"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
