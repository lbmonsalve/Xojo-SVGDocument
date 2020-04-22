#tag Class
Protected Class Rect
	#tag Method, Flags = &h0
		Function Clone() As Rect
		  Return New Rect(Self.Left, Self.Top, Self.Width, Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(pnt1 As Point, pnt2 As Point)
		  Self.Left= pnt1.X
		  Self.Top= pnt1.Y
		  Self.Width= pnt2.X
		  Self.Height= pnt2.Y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(origin As Point, size As Size)
		  Self.Left= origin.X
		  Self.Top= origin.Y
		  Self.Width= size.Width
		  Self.Height= size.Height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(left As Single, top As Single, width As Single, Height As Single)
		  Self.Left= left
		  Self.Top= Top
		  Self.Width= width
		  Self.Height= Height
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contains(pnt As Point) As Boolean
		  If (pnt.X>= Self.Left And pnt.X<= Self.Right) And (pnt.Y>= Self.Top And pnt.Y<= Self.Bottom) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contains(other As Rect) As Boolean
		  If (other.Left>= Self.Left And other.Left<= Self.Right) And (other.Top>= Self.Top And Other.Top<= Self.Bottom) And _
		    (other.Right<= Self.Right And other.Bottom<= Self.Bottom) Then Return True
		    
		    Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Difference(other As Rect) As Rect()
		  Dim ret() As Rect
		  
		  If other Is Nil Or (Not Self.Intersects(other)) Or other.Contains(Self) Then Return ret
		  
		  'Dim top, bottom, left, right As Rect
		  
		  //compute the top rectangle
		  Dim raHeight As Single= other.Y- Self.Y
		  If raHeight>0 Then ret.Append New Rect(Self.X, Self.Y, Self.Width, raHeight)
		  
		  //compute the bottom rectangle
		  Dim rbY As Single= other.Y+ other.Height
		  Dim rbHeight As Single= Self.Height- (rbY- Self.Y)
		  If rbHeight> 0 And rbY< (Self.Y+ Self.Height) Then ret.Append New Rect(Self.X, rbY, Self.Width, rbHeight)
		  
		  Dim rectAYH As Single= Self.Y+ Self.Height
		  Dim y1, y2 As Single
		  If other.Y> Self.Y Then y1= other.Y Else y1= Self.Y
		  If rbY< rectAYH Then y2= rbY Else y2= rectAYH
		  Dim rcHeight As Single= y2- y1
		  
		  //compute the left rectangle
		  Dim rcWidth As Single= other.X- Self.X
		  If rcWidth> 0 And rcHeight> 0 Then ret.Append New Rect(Self.X, y1, rcWidth, rcHeight)
		  
		  //compute the right rectangle
		  Dim rbX As Single= other.X+ other.Width
		  Dim rdWidth As Single= Self.Width- (rbX- Self.X)
		  If rdWidth> 0 Then ret.Append New Rect(rbX, y1, rdWidth, rcHeight)
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetPoint() As Point()
		  Dim pnts() As Point
		  
		  pnts.Append New Point(Left, top)
		  pnts.Append New Point(Right, top)
		  pnts.Append New Point(Right, Bottom)
		  pnts.Append New Point(Left, Bottom)
		  
		  Return pnts
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Inset(deltaX As Single, deltaY As Single) As Rect
		  Return New Rect(Self.Center.X- deltaX/ 2, Self.Center.Y- deltaY/ 2, deltaX, deltaY)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Intersection(other As Rect) As Rect
		  Dim x1 As Single= Max(Self.X, other.X)
		  Dim x2 As Single= Min(Self.X+ Self.Width, other.X+ other.Width)
		  Dim y1 As Single= Max(Self.Y, other.Y)
		  Dim y2 As Single= Min(Self.Y+ Self.Height, other.Y+ other.Height)
		  
		  If x2>= x1 And y2>= y1 Then Return New Rect(x1, y1, x2- x1, y2- y1) Else Return Empty
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Intersects(other As Rect) As Boolean
		  Return Not ((other.Left+ other.Width <= Self.Left) Or (other.Top+ other.Height<= Self.Top) Or _
		  (other.Left>= Self.Left+ Self.Width) Or (other.Top>= Self.Top+ Self.Height))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Offset(delta As Point)
		  Self.Left= Self.Left+ delta.X
		  Self.Top= Self.Top+ delta.Y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Offset(delta As Point) As Rect
		  Return New Rect(Self.Left+ delta.X, Self.Top+ delta.Y, Self.Width, Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Offset(deltaX As Single, deltaY As Single)
		  Self.Left= Self.Left+ deltaX
		  Self.Top= Self.Top+ deltaY
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Offset(deltaX As Single, deltaY As Single) As Rect
		  Return New Rect(Self.Left+ deltaX, Self.Top+ deltaY, Self.Width, Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As Rect) As Rect
		  Return New Rect(Self.Left+ rhs.Left, Self.Top+ rhs.Top, Self.Width+ rhs.Width, Self.Height+ rhs.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Add(rhs As String) As String
		  Return ToString+ rhs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_AddRight(lhs As Rect) As Rect
		  Return New Rect(Self.Left+ lhs.Left, Self.Top+ lhs.Top, Self.Width+ lhs.Width, Self.Height+ lhs.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_AddRight(lhs As String) As String
		  Return lhs+ ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Compare(rhs As Rect) As Integer
		  Dim a, b As Size
		  a= Self.Size
		  b= rhs.Size
		  
		  If a> b Then Return 1
		  If a< b Then Return -1
		  
		  Dim a1, b1 As Point
		  a1= Self.Origin
		  b1= rhs.Origin
		  
		  If a1> b1 Then Return 1
		  If a1< b1 Then Return -1
		  
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
		    
		    If json.HasName("Left") Then Self.Left= json.Value("Left").SingleValue
		    If json.HasName("Top") Then Self.Top= json.Value("Top").SingleValue
		    If json.HasName("Width") Then Self.Width= json.Value("Width").SingleValue
		    If json.HasName("Height") Then Self.Height= json.Value("Height").SingleValue
		  Catch e As JSONException
		    System.DebugLog CurrentMethodName+ " json.Load rhs (error): "+ e.Message
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Negate() As Rect
		  Return New Rect(-1* Self.Left, -1* Self.Top, -1* Self.Width, -1* Self.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Subtract(rhs As Rect) As Rect
		  Return New Rect(Self.Left- rhs.Left, Self.Top- rhs.Top, Self.Width- rhs.Width, Self.Height- rhs.Height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSONData(compact As Boolean = True) As JSONData
		  Dim ret As New JSONData
		  ret.Compact= compact
		  ret.DecimalFormat= "-##############0.0#####"
		  
		  ret.Value("Left")= Self.Left
		  ret.Value("Top")= Self.Top
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
		  #pragma Unused compact
		  
		  Return "{""Left"":"+ NumberToString(Self.Left)+ ",""Top"":"+ NumberToString(Self.Top)+ _
		  ",""Width"":"+ NumberToString(Self.Width)+ ",""Height"":"+ NumberToString(Self.Height)+ "}"
		  
		  'Return ToJSONData(compact).ToString
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Union(other As Rect) As Rect
		  Dim left As Single= Min(Self.Left, other.Left)
		  Dim top As Single= Min(Self.Top, other.Top)
		  Dim width As Single= Max(Self.Right, other.Right)- left
		  Dim height As Single= Max(Self.Bottom, other.Bottom)- top
		  
		  Return New Rect(left, top, width, height)
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Top+ Self.Height
			End Get
		#tag EndGetter
		Bottom As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New Point(Self.Left+ (Self.Width/ 2), Self.Top+ (Self.Height/ 2))
			End Get
		#tag EndGetter
		Center As Point
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New Rect
			End Get
		#tag EndGetter
		Shared Empty As Rect
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Height As Single
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Left+ (Self.Width/ 2)
			End Get
		#tag EndGetter
		HorizontalCenter As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Width<= 0 And Height<= 0
			End Get
		#tag EndGetter
		IsEmpty As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Left As Single
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New Point(Self.Left, Self.Top)
			End Get
		#tag EndGetter
		Origin As Point
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Left+ Self.Width
			End Get
		#tag EndGetter
		Right As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return New Size(Self.Width, Self.Height)
			End Get
		#tag EndGetter
		Size As Size
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Top As Single
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Top+ (Self.Height/ 2)
			End Get
		#tag EndGetter
		VerticalCenter As Single
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		Width As Single
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Left
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Left= value
			End Set
		#tag EndSetter
		Attributes( JsonIgnore ) X As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Left+ Self.Width
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Width= value- Self.Left
			End Set
		#tag EndSetter
		Attributes( JsonIgnore ) X2 As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Top
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Top= value
			End Set
		#tag EndSetter
		Attributes( JsonIgnore ) Y As Single
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return Self.Top+ Self.Height
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  Self.Height= value- Self.Top
			End Set
		#tag EndSetter
		Attributes( JsonIgnore ) Y2 As Single
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Bottom"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Height"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HorizontalCenter"
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
			Name="IsEmpty"
			Group="Behavior"
			Type="Boolean"
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
			Name="Right"
			Group="Behavior"
			Type="Single"
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
			Name="VerticalCenter"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Width"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="X"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="X2"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Y2"
			Group="Behavior"
			Type="Single"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
