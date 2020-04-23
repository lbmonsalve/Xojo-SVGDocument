#tag Class
Protected Class PointS
	#tag Method, Flags = &h0
		Function Clone() As PointS
		  Return New PointS(Self.X, Self.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(x1 As Single, y1 As Single)
		  Self.X= x1
		  Self.Y= y1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Distance(other As PointS) As Single
		  Return Sqrt((other.X- Self.X)^ 2+ (other.Y- Self.Y)^ 2)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Offset(deltaX As Single, deltaY As Single)
		  Self.X= Self.X+ deltaX
		  Self.Y= Self.Y+ deltaY
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As PointS) As PointS
		  Return New PointS(Self.X+ rhs.X, Self.Y+ rhs.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As String) As String
		  Return ToString+ rhs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_AddRight(lhs As PointS) As PointS
		  Return New PointS(Self.X+ lhs.X, Self.Y+ lhs.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_AddRight(lhs As String) As String
		  Return lhs+ ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(rhs As PointS) As Integer
		  Dim a, b As Single
		  a= Self.X^ 2+ Self.Y^ 2
		  b= rhs.X^ 2+ rhs.Y^ 2
		  
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
		    
		    If json.HasName("X") Then Self.X= json.Value("X").SingleValue
		    If json.HasName("Y") Then Self.Y= json.Value("Y").SingleValue
		  Catch e As JSONException
		    System.DebugLog CurrentMethodName+ " json.Load rhs (error): "+ e.Message
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Negate() As PointS
		  Return New PointS(-1* Self.X, -1* Self.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(rhs As PointS) As PointS
		  Return New PointS(Self.X- rhs.X, Self.Y- rhs.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSONData(compact As Boolean = True) As JSONData
		  Dim ret As New JSONData
		  ret.Compact= compact
		  
		  ret.Value("X")= Self.X
		  ret.Value("Y")= Self.Y
		  
		  Return ret
		  
		Exception e As JSONException
		  
		  System.DebugLog CurrentMethodName+ " JSONError:"+ e.Message
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(compact As Boolean = True) As String
		  #pragma Unused compact
		  
		  Return "{""X"":"+ NumberToString(Self.X)+ ",""Y"":"+ NumberToString(Self.Y)+ "}"
		  
		  'Return ToJSONData(compact).ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		X As Single
	#tag EndProperty

	#tag Property, Flags = &h0
		Y As Single
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
		#tag ViewProperty
			Name="X"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
