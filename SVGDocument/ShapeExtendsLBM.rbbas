#tag Module
Protected Module ShapeExtendsLBM
	#tag Method, Flags = &h0
		Function Clone(Extends obj As Object2D) As Object2D
		  Dim ret As Object2D
		  
		  If obj IsA ArcShape Then
		    Dim shape As ArcShape= ArcShape(obj)
		    Dim clone As New ArcShape
		    
		    CloneTo clone, shape
		    
		    ret= clone
		  ElseIf obj IsA OvalShape Then
		    Dim shape As OvalShape= OvalShape(obj)
		    Dim clone As New OvalShape
		    
		    CloneTo clone, shape
		    
		    ret= clone
		  ElseIf obj IsA RoundRectShape Then
		    Dim shape As RoundRectShape= RoundRectShape(obj)
		    Dim clone As New RoundRectShape
		    
		    CloneTo clone, shape
		    
		    ret= clone
		  ElseIf obj IsA PixmapShape Then
		    Dim shape As PixmapShape= PixmapShape(obj)
		    Dim clone As New PixmapShape
		    
		    CloneTo clone, shape
		    clone.Image= Picture.FromData(shape.Image.GetData(Picture.FormatPNG))
		    
		    ret= clone
		  ElseIf obj IsA RectShape Then
		    Dim shape As RectShape= RectShape(obj)
		    Dim clone As New RectShape
		    
		    CloneTo clone, shape
		    
		    ret= clone
		  ElseIf obj IsA StringShape Then
		    Dim shape As StringShape= StringShape(obj)
		    Dim clone As New StringShape
		    
		    CloneTo clone, shape
		    
		    ret= clone
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    Dim clone As New CurveShape
		    
		    CloneTo clone, shape
		    If shape.Order= 1 Then
		      clone.ControlX(0)= shape.ControlX(0)
		      clone.ControlY(0)= shape.ControlY(0)
		    ElseIf shape.Order= 2 Then
		      clone.ControlX(0)= shape.ControlX(0)
		      clone.ControlY(0)= shape.ControlY(0)
		      clone.ControlX(1)= shape.ControlX(1)
		      clone.ControlY(1)= shape.ControlY(1)
		    End If
		    
		    ret= clone
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    Dim clone As New FigureShape
		    
		    For i As Integer= 0 To shape.Count- 1
		      clone.Append CurveShape(shape.Item(i).Clone)
		    Next
		    
		    ret= clone
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    Dim clone As New Group2D
		    
		    For i As Integer= 0 To shape.Count- 1
		      clone.Append shape.Item(i).Clone
		    Next
		    
		    ret= clone
		  ElseIf obj IsA Object2D Then
		    Break
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CloneTo(obj As Object2D, from As Object2D)
		  Dim ti As Introspection.TypeInfo= Introspection.GetType(obj)
		  Dim tiFrom As Introspection.TypeInfo= Introspection.GetType(from)
		  
		  If ti.FullName<> tiFrom.FullName Then Return
		  
		  For Each prop As Introspection.PropertyInfo In ti.GetProperties
		    If prop.IsPublic And prop.CanRead And prop.CanWrite Then
		      prop.Value(obj)= prop.Value(from)
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Contains(Extends fig As FigureShape, other As FigureShape) As Boolean
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert Not (fig Is Nil)
		  
		  If fig.Count= 0 Then Return False
		  If other.Count= 0 Then Return False
		  
		  Dim verts() As PointS
		  
		  Dim pnt As PointS
		  For i As Integer= 0 To fig.Count- 1
		    Dim curv As CurveShape= fig.Item(i)
		    
		    If i= 0 Then
		      pnt= New PointS(curv.X, curv.Y)
		      verts.Append pnt
		    End If
		    verts.Append New PointS(curv.X2, curv.Y2)
		  Next
		  If verts(verts.Ubound)<> pnt Then verts.Append pnt
		  
		  Dim nPointsIn As Integer
		  
		  For i As Integer= 0 To other.Count- 1
		    Dim curv As CurveShape= other.Item(i)
		    
		    Dim pnt1 As PointS
		    If i= 0 Then
		      pnt1= New PointS(curv.X, curv.Y)
		      If Shape2D.PointInPolyWN(pnt1, verts) Then nPointsIn= nPointsIn+ 1
		    End If
		    
		    pnt1= New PointS(curv.X2, curv.Y2)
		    If Shape2D.PointInPolyWN(pnt1, verts) Then nPointsIn= nPointsIn+ 1
		  Next
		  
		  If (nPointsIn/ other.Count)> .9 Then Return True Else Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CopyStyleFrom(Extends obj As Object2D, other As Object2D)
		  'LBMSoft.Debug.Assert Not (obj Is Nil)
		  
		  obj.Border= other.Border
		  obj.BorderColor= other.BorderColor
		  obj.BorderWidth= other.BorderWidth
		  obj.Fill= other.Fill
		  obj.FillColor= other.FillColor
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeArcShape(shpJItem As JSONData) As ArcShape
		  Dim shp As New ArcShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("ArcAngle") Then shp.ArcAngle= shpJItem.Value("ArcAngle").DoubleValue
		  If shpJItem.HasName("Height") Then shp.Height= shpJItem.Value("Height").DoubleValue
		  If shpJItem.HasName("Segments") Then shp.Segments= shpJItem.Value("Segments").IntegerValue
		  If shpJItem.HasName("StartAngle") Then shp.StartAngle= shpJItem.Value("StartAngle").DoubleValue
		  If shpJItem.HasName("Width") Then shp.Width= shpJItem.Value("Width").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeCurveShape(shpJItem As JSONData) As CurveShape
		  Dim shp As New CurveShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Order") Then
		    shp.Order= shpJItem.Value("Order").IntegerValue
		    For j As Integer= 0 To shp.Order
		      If shpJItem.HasName("ControlX."+ Str(j)) Then shp.ControlX(j)= shpJItem.Value("ControlX."+ Str(j)).DoubleValue
		      If shpJItem.HasName("ControlY."+ Str(j)) Then shp.ControlY(j)= shpJItem.Value("ControlY."+ Str(j)).DoubleValue
		    Next
		    
		  End If
		  
		  If shpJItem.HasName("Segments") Then shp.Segments= shpJItem.Value("Segments").IntegerValue
		  If shpJItem.HasName("X2") Then shp.X2= shpJItem.Value("X2").DoubleValue
		  If shpJItem.HasName("Y2") Then shp.Y2= shpJItem.Value("Y2").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeFigureShape(shpJItem As JSONData) As FigureShape
		  Dim shp As New FigureShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("$Items") Then
		    Dim shpJItems As JSONData= shpJItem.Value("$Items")
		    
		    If shpJItems.IsArray Then
		      For j As Integer= 0 To shpJItems.Count- 1
		        Dim shpJItemsItem As JSONData= shpJItems.Value(j)
		        
		        Dim type As String
		        If shpJItemsItem.HasName("$Type") Then type= shpJItemsItem.Value("$Type").StringValue
		        
		        Select Case type
		        Case "CurveShape"
		          shp.Append GetShapeCurveShape(shpJItemsItem)
		        End Select
		        
		      Next
		    End If
		    
		  End If
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeObject2D(shpJItem As JSONData) As Object2D
		  Dim shp As New Object2D
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeOvalShape(shpJItem As JSONData) As OvalShape
		  Dim shp As New OvalShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Height") Then shp.Height= shpJItem.Value("Height").DoubleValue
		  If shpJItem.HasName("Segments") Then shp.Segments= shpJItem.Value("Segments").IntegerValue
		  If shpJItem.HasName("Width") Then shp.Width= shpJItem.Value("Width").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapePixmapShape(shpJItem As JSONData) As PixmapShape
		  Dim shp As New PixmapShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Height") Then shp.Height= shpJItem.Value("Height").DoubleValue
		  If shpJItem.HasName("Image") Then shp.Image= Picture.FromData(DecodeBase64(shpJItem.Value("Image").StringValue))
		  If shpJItem.HasName("SourceHeight") Then shp.SourceHeight= shpJItem.Value("SourceHeight").IntegerValue
		  If shpJItem.HasName("SourceLeft") Then shp.SourceLeft= shpJItem.Value("SourceLeft").IntegerValue
		  If shpJItem.HasName("SourceTop") Then shp.SourceTop= shpJItem.Value("SourceTop").IntegerValue
		  If shpJItem.HasName("SourceWidth") Then shp.SourceWidth= shpJItem.Value("SourceWidth").IntegerValue
		  If shpJItem.HasName("Width") Then shp.Width= shpJItem.Value("Width").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeRectShape(shpJItem As JSONData) As RectShape
		  Dim shp As New RectShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Height") Then shp.Height= shpJItem.Value("Height").DoubleValue
		  If shpJItem.HasName("Width") Then shp.Width= shpJItem.Value("Width").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeRoundRectShape(shpJItem As JSONData) As RoundRectShape
		  Dim shp As New RoundRectShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Cornerheight") Then shp.Cornerheight= shpJItem.Value("Cornerheight").DoubleValue
		  If shpJItem.HasName("Cornerwidth") Then shp.Cornerwidth= shpJItem.Value("Cornerwidth").DoubleValue
		  If shpJItem.HasName("Height") Then shp.Height= shpJItem.Value("Height").DoubleValue
		  If shpJItem.HasName("Segments") Then shp.Segments= shpJItem.Value("Segments").IntegerValue
		  If shpJItem.HasName("Width") Then shp.Width= shpJItem.Value("Width").DoubleValue
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetShapeStringShape(shpJItem As JSONData) As StringShape
		  Dim shp As New StringShape
		  
		  ToGroup2DDefaults shp, shpJItem
		  
		  If shpJItem.HasName("Bold") Then shp.Bold= shpJItem.Value("Bold").BooleanValue
		  If shpJItem.HasName("HorizontalAlignment") Then _
		  shp.HorizontalAlignment= Ctype(shpJItem.Value("HorizontalAlignment").IntegerValue, StringShape.Alignment)
		  If shpJItem.HasName("Italic") Then shp.Italic= shpJItem.Value("Italic").BooleanValue
		  If shpJItem.HasName("Text") Then shp.Text= shpJItem.Value("Text").StringValue
		  If shpJItem.HasName("TextFont") Then shp.TextFont= shpJItem.Value("TextFont").StringValue
		  If shpJItem.HasName("TextSize") Then shp.TextSize= shpJItem.Value("TextSize").DoubleValue
		  If shpJItem.HasName("Underline") Then shp.Underline= shpJItem.Value("Underline").BooleanValue
		  If shpJItem.HasName("VerticalAlignment") Then _
		  shp.VerticalAlignment= CType(shpJItem.Value("VerticalAlignment").IntegerValue, StringShape.Alignment)
		  
		  Return shp
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSize(Extends obj As Object2D) As SizeS
		  'LBMSoft.Debug.Assert Not (obj Is Nil)
		  
		  Dim pMin As PointS
		  Dim pMax As PointS
		  
		  obj.GetSize(pMin, pMax)
		  
		  If pMin Is Nil Or pMax Is Nil Then Return New SizeS
		  
		  Return New SizeS(pMax.X- pMin.X, pMax.Y- pMin.Y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub GetSize(Extends obj As Object2D, ByRef pMin As PointS, ByRef pMax As PointS)
		  If obj IsA ArcShape Then
		    Dim shape As ArcShape= ArcShape(obj)
		    Dim pnt1 As New PointS(shape.X- (shape.Width/ 2)- (shape.BorderWidth/ 2), shape.Y- (shape.Height/ 2)- (shape.BorderWidth/ 2))
		    Dim pnt2 As New PointS(shape.X+ (shape.Width/ 2)+ (shape.BorderWidth/ 2), shape.Y+ (shape.Height/ 2)+ (shape.BorderWidth/ 2))
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    
		    PointMinMax pMin, pMax, New PointS(shape.X, shape.Y), New PointS(shape.X2, shape.Y2)
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).GetSize(pMin, pMax)
		    Next
		  ElseIf obj IsA OvalShape Then
		    Dim shape As OvalShape= OvalShape(obj)
		    Dim pnt1 As New PointS(shape.X- (shape.Width/ 2)- (shape.BorderWidth/ 2), shape.Y- (shape.Height/ 2)- (shape.BorderWidth/ 2))
		    Dim pnt2 As New PointS(shape.X+ (shape.Width/ 2)+ (shape.BorderWidth/ 2), shape.Y+ (shape.Height/ 2)+ (shape.BorderWidth/ 2))
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA PixMapShape Then
		    Dim shape As PixMapShape= PixMapShape(obj)
		    Dim pnt1 As New PointS(shape.X- (shape.SourceWidth/ 2), shape.Y- (shape.SourceHeight/ 2))
		    Dim pnt2 As New PointS(shape.X+ (shape.SourceWidth/ 2), shape.Y+ (shape.SourceHeight/ 2))
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA RectShape Then
		    Dim shape As RectShape= RectShape(obj)
		    Dim pnt1 As New PointS(shape.X- (shape.Width/ 2)- (shape.BorderWidth/ 2), shape.Y- (shape.Height/ 2)- (shape.BorderWidth/ 2))
		    Dim pnt2 As New PointS(shape.X+ (shape.Width/ 2)+ (shape.BorderWidth/ 2), shape.Y+ (shape.Height/ 2)+ (shape.BorderWidth/ 2))
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA RoundRectShape Then
		    Dim shape As RoundRectShape= RoundRectShape(obj)
		    Dim pnt1 As New PointS(shape.X- (shape.Width/ 2)- (shape.BorderWidth/ 2), shape.Y- (shape.Height/ 2)- (shape.BorderWidth/ 2))
		    Dim pnt2 As New PointS(shape.X+ (shape.Width/ 2)+ (shape.BorderWidth/ 2), shape.Y+ (shape.Height/ 2)+ (shape.BorderWidth/ 2))
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA StringShape Then
		    Dim shape As StringShape= StringShape(obj)
		    Dim pnt1, pnt2 As PointS
		    
		    If shape.HorizontalAlignment= StringShape.Alignment.Center Then
		      pnt1= New PointS(shape.X- (shape.StringWidth/ 2), shape.Y- shape.TextAscent)
		      pnt2= New PointS(shape.X+ (shape.StringWidth/ 2), shape.Y+ (shape.TextSize- shape.TextAscent))
		    ElseIf shape.HorizontalAlignment= StringShape.Alignment.Right Then
		      pnt1= New PointS(shape.X- shape.StringWidth, shape.Y- shape.TextAscent)
		      pnt2= New PointS(shape.X, shape.Y+ (shape.TextSize- shape.TextAscent))
		    Else // left
		      pnt1= New PointS(shape.X, shape.Y- shape.TextAscent)
		      pnt2= New PointS(shape.X+ shape.StringWidth, shape.Y+ (shape.TextSize- shape.TextAscent))
		    End If
		    
		    PointMinMax pMin, pMax, pnt1, pnt2
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).GetSize(pMin, pMax)
		    Next
		  Else
		    PointMinMax pMin, pMax, New PointS(obj.X, obj.Y)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Opacity(Extends obj As Object2D, Assigns value As Integer)
		  'LBMSoft.Debug.Assert Not (obj Is Nil)
		  
		  If Not (obj IsA PixmapShape) Then
		    obj.Border= value
		  End If
		  obj.Fill= value
		  
		  If obj IsA Group2D Then
		    Dim grp As Group2D= Group2D(obj)
		    For i As Integer= 0 To grp.Count- 1
		      grp.Item(i).Opacity= value
		    Next
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PointList(Extends obj As Object2D) As SVGPointList()
		  Dim ret() As SVGPointList
		  
		  If obj IsA ArcShape Then
		    System.DebugLog CurrentMethodName+ " ArcShape" // TODO:
		  ElseIf obj IsA OvalShape Then
		    System.DebugLog CurrentMethodName+ " OvalShape" // TODO:
		  ElseIf obj IsA RoundRectShape Then
		    System.DebugLog CurrentMethodName+ " RoundRectShape" // TODO:
		  ElseIf obj IsA PixmapShape Then
		    System.DebugLog CurrentMethodName+ " PixmapShape" // TODO:
		  ElseIf obj IsA RectShape Then
		    System.DebugLog CurrentMethodName+ " RectShape" // TODO:
		  ElseIf obj IsA StringShape Then
		    System.DebugLog CurrentMethodName+ " StringShape" // TODO:
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    Dim pointList As New SVGPointList
		    
		    pointList.Append New PointS(shape.X, shape.Y)
		    pointList.Append New PointS(shape.X2, shape.Y2)
		    
		    ret.Append pointList
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).PointList(ret)
		    Next
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).PointList(ret)
		    Next
		  ElseIf obj IsA Object2D Then
		    Break
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PointList(Extends obj As Object2D, ret() As SVGPointList)
		  If obj IsA ArcShape Then
		    System.DebugLog CurrentMethodName+ " ret() ArcShape" // TODO:
		  ElseIf obj IsA OvalShape Then
		    System.DebugLog CurrentMethodName+ " ret() OvalShape" // TODO:
		  ElseIf obj IsA RoundRectShape Then
		    System.DebugLog CurrentMethodName+ " ret() RoundRectShape" // TODO:
		  ElseIf obj IsA PixmapShape Then
		    System.DebugLog CurrentMethodName+ " ret() PixmapShape" // TODO:
		  ElseIf obj IsA RectShape Then
		    System.DebugLog CurrentMethodName+ " ret() RectShape" // TODO:
		  ElseIf obj IsA StringShape Then
		    System.DebugLog CurrentMethodName+ " ret() StringShape" // TODO:
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    Dim pointList As New SVGPointList
		    
		    pointList.Append New PointS(shape.X, shape.Y)
		    pointList.Append New PointS(shape.X2, shape.Y2)
		    
		    ret.Append pointList
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    Dim pointList As New SVGPointList
		    
		    For i As Integer= 0 To shape.Count- 1
		      Dim points() As PointS= shape.Item(i).Points
		      
		      For j As Integer= 0 To points.Ubound
		        pointList.Append points(j)
		      Next
		    Next
		    
		    Dim points() As PointS= pointList.Points
		    Try
		      If points(points.Ubound)<> points(0) Then // to close shape
		        points.Append points(0)
		      End If
		    Catch exc As RuntimeException
		      System.DebugLog CurrentMethodName+ " exc:"+ Introspection.GetType(exc).Name
		    End Try
		    
		    ret.Append pointList
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).PointList(ret)
		    Next
		  ElseIf obj IsA Object2D Then
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PointMinMax(ByRef pMin As PointS, ByRef pMax As PointS, ParamArray points As PointS)
		  For Each point As PointS In points
		    If pMin Is Nil Then
		      pMin= New PointS(point.X, point.Y)
		    Else
		      If point.X< pMin.X Then pMin.X= point.X
		      If point.Y< pMin.Y Then pMin.Y= point.Y
		    End If
		    
		    If pMax Is Nil Then
		      pMax= New PointS(point.X, point.Y)
		    Else
		      If point.X> pMax.X Then pMax.X= point.X
		      If point.Y> pMax.Y Then pMax.Y= point.Y
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Points(Extends obj As Object2D) As PointS()
		  Dim ret() As PointS
		  
		  If obj IsA ArcShape Then
		    System.DebugLog CurrentMethodName+ " ArcShape" // TODO:
		  ElseIf obj IsA OvalShape Then
		    System.DebugLog CurrentMethodName+ " OvalShape" // TODO:
		  ElseIf obj IsA RoundRectShape Then
		    System.DebugLog CurrentMethodName+ " RoundRectShape" // TODO:
		  ElseIf obj IsA PixmapShape Then
		    System.DebugLog CurrentMethodName+ " PixmapShape" // TODO:
		  ElseIf obj IsA RectShape Then
		    System.DebugLog CurrentMethodName+ " RectShape" // TODO:
		  ElseIf obj IsA StringShape Then
		    System.DebugLog CurrentMethodName+ " StringShape" // TODO:
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    
		    ret.Append New PointS(shape.X, shape.Y)
		    ret.Append New PointS(shape.X2, shape.Y2)
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      Dim points() As PointS= shape.Item(i).Points
		      
		      For j As Integer= 0 To points.Ubound
		        ret.Append points(j)
		      Next
		    Next
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      Dim points() As PointS= shape.Item(i).Points
		      For j As Integer= 0 To points.Ubound
		        ret.Append points(j)
		      Next
		    Next
		  ElseIf obj IsA Object2D Then
		    Break
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RotateItems(Extends shape As Group2D, angle As Double)
		  'LBMSoft.Debug.Assert Not (shape Is Nil)
		  
		  For i As Integer= 0 To shape.Count- 1
		    Dim item As Object2D= shape.Item(i)
		    
		    If item IsA Group2D Then
		      Group2D(item).RotateItems angle
		    ElseIf item IsA FigureShape Then
		      If FigureShape(item).Count= 0 Then Return
		      
		      Dim xValues(), yValues() As Double
		      
		      For j As Integer= 0 To FigureShape(item).Count- 1
		        Dim line As CurveShape= CurveShape(FigureShape(item).Item(j))
		        xValues.Append line.X
		        xValues.Append line.X2
		        yValues.Append line.Y
		        yValues.Append line.Y2
		      Next
		      
		      xValues.Sort
		      yValues.Sort
		      
		      Dim width As Double= xValues(xValues.Ubound)- xValues(0)
		      Dim height As Double= yValues(yValues.Ubound)- yValues(0)
		      
		      // don't work
		      'Dim x As Double= item.X
		      'Dim y As Double= item.Y
		      '
		      'item.X= 0
		      'item.Y= 0
		      'item.Rotation= angle
		      '
		      'Dim quart As Double= (22/ 7)/ 2 // PI/2
		      'Dim quartAngle As Double= angle
		      'If angle< 0 Then quartAngle= (quart* 4)+ angle
		      '
		      'If quartAngle>= 0 and quartAngle< quart Then // 1st quart
		      'item.X= x+ width
		      'item.Y= y+ (height/ 2)
		      'ElseIf quartAngle>= quart And quartAngle< quart* 2 Then // 2nd quart
		      'item.X= x+ width //+ (width/ 2)
		      'item.Y= y+ height//+ (height/ 2)- 2
		      'ElseIf quartAngle>= quart* 2 And quartAngle< quart* 3 Then // 3rd quart
		      'item.X= x+ (width/ 2)
		      'item.Y= y+ height//+ (height/ 2)
		      'Else // 4rd quart
		      'item.X= x- (width/ 2)
		      'item.Y= y+ (height/ 2)
		      'End If
		      // don't work
		      
		      // work ONLY CENTER !!
		      Dim dx As Double= xValues(0)+ (width/ 2)
		      Dim dy As Double= yValues(0)+ (height/ 2)
		      
		      Dim matrixT1() As Double= Array(_
		      1.0, 0.0, dx, _
		      0.0, 1.0, dy, _
		      0.0, 0.0, 1.0)
		      
		      Dim matrixT2() As Double= Array(_
		      1.0, 0.0, -dx, _
		      0.0, 1.0, -dy, _
		      0.0, 0.0, 1.0)
		      
		      Dim matrixR() As Double= Array(_
		      Cos(angle), -Sin(angle), 0.0, _
		      Sin(angle), Cos(angle), 0.0, _
		      0.0, 0.0, 1.0)
		      
		      Dim matrixA() As Double= SVGDocument.MatrixMultiply(matrixT1, matrixR)
		      matrixA= SVGDocument.MatrixMultiply(matrixA, matrixT2)
		      
		      For j As Integer= 0 To FigureShape(item).Count- 1
		        Dim line As CurveShape= CurveShape(FigureShape(item).Item(j))
		        
		        Dim pnt1 As PointS= SVGDocument.TransformPoint(New PointS(line.X, line.Y), matrixA)
		        Dim pnt2 As PointS= SVGDocument.TransformPoint(New PointS(line.X2, line.Y2), matrixA)
		        
		        line.X= pnt1.X
		        line.Y= pnt1.Y
		        line.X2= pnt2.X
		        line.Y2= pnt2.Y
		      Next
		      
		      item.X= -dx
		      item.Y= -dy
		      
		      'SVGDocument.DebugLog item, 50, 50, 2, 100, 100
		      // work
		      
		    Else
		      Dim x As Double= item.X
		      Dim y As Double= item.Y
		      
		      item.X= 0
		      item.Y= 0
		      
		      item.Rotation= angle
		      
		      item.X= x
		      item.Y= y
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFillColor(Extends obj As Object2D, Assigns colr As Color)
		  If obj IsA ArcShape Then
		    System.DebugLog CurrentMethodName+ " ArcShape"
		  ElseIf obj IsA OvalShape Then
		    System.DebugLog CurrentMethodName+ " OvalShape"
		  ElseIf obj IsA RoundRectShape Then
		    System.DebugLog CurrentMethodName+ " RoundRectShape"
		  ElseIf obj IsA PixmapShape Then
		    System.DebugLog CurrentMethodName+ " PixmapShape"
		  ElseIf obj IsA RectShape Then
		    System.DebugLog CurrentMethodName+ " RectShape"
		  ElseIf obj IsA StringShape Then
		    System.DebugLog CurrentMethodName+ " StringShape"
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    
		    shape.FillColor= colr
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).FillColor= colr
		    Next
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    For i As Integer= 0 To shape.Count- 1
		      shape.Item(i).FillColor= colr
		    Next
		  ElseIf obj IsA Object2D Then
		    Break
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringWidth(Extends strShape As StringShape) As Double
		  'LBMSoft.Debug.Assert Not (strShape Is Nil)
		  
		  Dim g As Graphics= PicString.Graphics
		  
		  g.TextFont= strShape.TextFont
		  g.TextSize= strShape.TextSize
		  g.Bold= strShape.Bold
		  g.Underline= strShape.Underline
		  
		  Return g.StringWidth(strShape.Text)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextAscent(Extends strShape As StringShape) As Double
		  'LBMSoft.Debug.Assert Not (strShape Is Nil)
		  
		  Dim g As Graphics= PicString.Graphics
		  
		  g.TextFont= strShape.TextFont
		  g.TextSize= strShape.TextSize
		  g.Bold= strShape.Bold
		  g.Underline= strShape.Underline
		  
		  Return g.TextAscent
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToColor(Extends str As String) As Color
		  Dim colr As Color
		  
		  If str.InStr("#")> 0 Then
		    Dim red As String= str.Mid(2, 2)
		    Dim green As String= str.Mid(4, 2)
		    Dim blue As String= str.Mid(6, 2)
		    Dim alpha As String= str.Mid(8, 2)
		    
		    colr= RGB(Val("&h"+ red), Val("&h"+ green), Val("&h"+ blue), Val("&h"+ alpha))
		  End If
		  
		  Return colr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToGroup2D(Extends str As String) As Group2D
		  'LBMSoft.Debug.Assert (str.Len> 0)
		  
		  Dim shapeJson As New JSONData
		  
		  Try
		    shapeJson.Load(str)
		  Catch e As JSONException
		    System.DebugLog CurrentMethodName+ "shapeJson.Load(str) (error):"+ e.Message
		    Return Nil
		  End Try
		  
		  Dim shape As New Group2D
		  
		  Dim type As String
		  If shapeJson.HasName("$Type") Then type= shapeJson.Value("$Type").StringValue
		  
		  Select Case type
		  Case "Group2D"
		    ToGroup2DDefaults shape, shapeJson
		    
		    If shapeJson.HasName("$Items") Then
		      Dim shapeJsonItems As JSONData= shapeJson.Value("$Items")
		      
		      If shapeJsonItems.IsArray Then
		        For i As Integer= 0 To shapeJsonItems.Count- 1
		          Dim shpJItem As JSONData= shapeJsonItems.Value(i)
		          
		          Dim typeItem As String
		          If shpJItem.HasName("$Type") Then typeItem= shpJItem.Value("$Type").StringValue
		          
		          Select Case typeItem
		          Case "ArcShape"
		            shape.Append GetShapeArcShape(shpJItem)
		          Case "OvalShape"
		            shape.Append GetShapeOvalShape(shpJItem)
		          Case "RoundRectShape"
		            shape.Append GetShapeRoundRectShape(shpJItem)
		          Case "PixmapShape"
		            shape.Append GetShapePixmapShape(shpJItem)
		          Case "RectShape"
		            shape.Append GetShapeRectShape(shpJItem)
		          Case "StringShape"
		            shape.Append GetShapeStringShape(shpJItem)
		          Case "CurveShape"
		            shape.Append GetShapeCurveShape(shpJItem)
		          Case "FigureShape"
		            shape.Append GetShapeFigureShape(shpJItem)
		          Case "Group2D"
		            shape.Append shpJItem.ToString.ToGroup2D
		          Case "Object2D"
		            shape.Append GetShapeObject2D(shpJItem)
		          End Select
		          
		        Next
		      End If
		      
		    End If
		    
		  Case "ArcShape"
		    shape.Append GetShapeArcShape(shapeJson)
		  Case "OvalShape"
		    shape.Append GetShapeOvalShape(shapeJson)
		  Case "RoundRectShape"
		    shape.Append GetShapeRoundRectShape(shapeJson)
		  Case "PixmapShape"
		    shape.Append GetShapePixmapShape(shapeJson)
		  Case "RectShape"
		    shape.Append GetShapeRectShape(shapeJson)
		  Case "StringShape"
		    shape.Append GetShapeStringShape(shapeJson)
		  Case "CurveShape"
		    shape.Append GetShapeCurveShape(shapeJson)
		  Case "FigureShape"
		    shape.Append GetShapeFigureShape(shapeJson)
		  Case "Group2D"
		    shape.Append shapeJson.ToString.ToGroup2D
		  Case "Object2D"
		    shape.Append GetShapeObject2D(shapeJson)
		  End Select
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ToGroup2DDefaults(shape As Object2D, shapeJson As JSONData)
		  If shapeJson.HasName("BorderColor") Then shape.BorderColor= shapeJson.Value("BorderColor").StringValue.ToColor
		  If shapeJson.HasName("Border") Then shape.Border= shapeJson.Value("Border").DoubleValue
		  If shapeJson.HasName("BorderWidth") Then shape.BorderWidth= shapeJson.Value("BorderWidth").DoubleValue
		  If shapeJson.HasName("FillColor") Then shape.FillColor= shapeJson.Value("FillColor").StringValue.ToColor
		  If shapeJson.HasName("Fill") Then shape.Fill= shapeJson.Value("Fill").DoubleValue
		  If shapeJson.HasName("Scale") Then shape.Scale= shapeJson.Value("Scale").DoubleValue
		  If shapeJson.HasName("Rotation") Then shape.Rotation= shapeJson.Value("Rotation").DoubleValue
		  If shapeJson.HasName("X") Then shape.X= shapeJson.Value("X").DoubleValue
		  If shapeJson.HasName("Y") Then shape.Y= shapeJson.Value("Y").DoubleValue
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToHex(Extends colr As Color) As String
		  Dim red As String= Hex(colr.Red)
		  If red="0" Then red= "00"
		  
		  Dim green As String= Hex(colr.Green)
		  If green="0" Then green= "00"
		  
		  Dim blue As String= Hex(colr.Blue)
		  If blue="0" Then blue= "00"
		  
		  Dim alpha As String= Hex(colr.Alpha)
		  If alpha="0" Then alpha= ""
		  
		  Return "#"+ red+ green+ blue+ alpha
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToJSONData(Extends obj As Object2D, compact As Boolean = True) As JSONData
		  'LBMSoft.Debug.Assert Not (obj Is Nil)
		  
		  Dim ret As New JSONData
		  ret.Compact= compact
		  
		  If obj IsA ArcShape Then
		    Dim shape As ArcShape= ArcShape(obj)
		    
		    ret.Value("$Type")= "ArcShape"
		    ToJSONDataDefaults shape, ret
		    
		    ret.Value("ArcAngle")= shape.ArcAngle
		    ret.Value("StartAngle")= shape.StartAngle
		    ret.Value("Segments")= shape.Segments
		    
		  ElseIf obj IsA OvalShape Then
		    Dim shape As OvalShape= OvalShape(obj)
		    
		    ret.Value("$Type")= "OvalShape"
		    ToJSONDataDefaults shape, ret
		    
		    ret.Value("Height")= shape.Height
		    ret.Value("Segments")= shape.Segments
		    ret.Value("Width")= shape.Width
		    
		  ElseIf obj IsA RoundRectShape Then
		    Dim shape As RoundRectShape= RoundRectShape(obj)
		    
		    ret.Value("$Type")= "RoundRectShape"
		    ToJSONDataDefaults shape, ret
		    If shape.Fill= 0 Then // special case
		      Dim colr As Color= &c000000FF
		      ret.Value("FillColor")= colr.ToHex
		    End If
		    
		    ret.Value("Cornerheight")= shape.Cornerheight
		    ret.Value("Cornerwidth")= shape.Cornerwidth
		    ret.Value("Height")= shape.Height
		    ret.Value("Segments")= shape.Segments
		    ret.Value("Width")= shape.Width
		    
		  ElseIf obj IsA PixmapShape Then
		    Dim shape As PixmapShape= PixmapShape(obj)
		    
		    ret.Value("$Type")= "PixmapShape"
		    ToJSONDataDefaults shape, ret
		    
		    ret.Value("Height")= shape.Height
		    If shape.Image<> Nil Then ret.Value("Image")= EncodeBase64(shape.Image.GetData(Picture.FormatPNG), 0)
		    ret.Value("SourceHeight")= shape.SourceHeight
		    ret.Value("SourceLeft")= shape.SourceLeft
		    ret.Value("SourceTop")= shape.SourceTop
		    ret.Value("SourceWidth")= shape.SourceWidth
		    ret.Value("Width")= shape.Width
		    
		  ElseIf obj IsA RectShape Then
		    Dim shape As RectShape= RectShape(obj)
		    
		    ret.Value("$Type")= "RectShape"
		    ToJSONDataDefaults shape, ret
		    If shape.Fill= 0 Then // special case
		      Dim colr As Color= &c000000FF
		      ret.Value("FillColor")= colr.ToHex
		    End If
		    
		    ret.Value("Height")= shape.Height
		    ret.Value("Width")= shape.Width
		    
		  ElseIf obj IsA StringShape Then
		    Dim shape As StringShape= StringShape(obj)
		    
		    ret.Value("$Type")= "StringShape"
		    ToJSONDataDefaults shape, ret
		    
		    ret.Value("Bold")= shape.Bold
		    ret.Value("HorizontalAlignment")= shape.HorizontalAlignment
		    ret.Value("Italic")= shape.Italic
		    ret.Value("Text")= shape.Text
		    ret.Value("TextFont")= shape.TextFont
		    ret.Value("TextSize")= shape.TextSize
		    ret.Value("Underline")= shape.Underline
		    ret.Value("VerticalAlignment")= shape.VerticalAlignment
		    
		  ElseIf obj IsA CurveShape Then
		    Dim shape As CurveShape= CurveShape(obj)
		    
		    ret.Value("$Type")= "CurveShape"
		    ToJSONDataDefaults shape, ret
		    
		    If shape.X2<> 0 Then ret.Value("X2")= shape.X2
		    If shape.Y2<> 0 Then ret.Value("Y2")= shape.Y2
		    If shape.Order<> 0 Then ret.Value("Order")= shape.Order
		    
		    If shape.Order= 1 Then
		      ret.Value("ControlX."+ Str(0))= shape.ControlX(0)
		      ret.Value("ControlY."+ Str(0))= shape.ControlY(0)
		    ElseIf shape.Order= 2 Then
		      ret.Value("ControlX."+ Str(0))= shape.ControlX(0)
		      ret.Value("ControlY."+ Str(0))= shape.ControlY(0)
		      ret.Value("ControlX."+ Str(1))= shape.ControlX(1)
		      ret.Value("ControlY."+ Str(1))= shape.ControlY(1)
		    End If
		    
		  ElseIf obj IsA FigureShape Then
		    Dim shape As FigureShape= FigureShape(obj)
		    
		    ret.Value("$Type")= "FigureShape"
		    ToJSONDataDefaults shape, ret
		    
		    ret.Value("Count")= shape.Count
		    
		    Dim shapeJsonItems As New JSONData
		    
		    For i As Integer= 0 To shape.Count- 1
		      Dim c As CurveShape= shape.Item(i)
		      shapeJsonItems.Append c.ToJSONData(compact)
		    Next
		    
		    ret.Value("$Items")= shapeJsonItems
		    
		  ElseIf obj IsA Group2D Then
		    Dim shape As Group2D= Group2D(obj)
		    
		    ret.Value("$Type")= "Group2D"
		    ToJSONDataDefaults shape, ret
		    ret.Remove "Fill"
		    If shape.Fill<> 100 Then ret.Value("Fill")= shape.Fill // special case
		    
		    ret.Value("Count")= shape.Count
		    
		    Dim shapeJsonItems As New JSONData
		    
		    For i As Integer= 0 To shape.Count- 1
		      shapeJsonItems.Append shape.Item(i).ToJSONData(compact)
		    Next
		    
		    ret.Value("$Items")= shapeJsonItems
		    
		  ElseIf obj IsA Object2D Then
		    Dim shape As Object2D= Object2D(obj)
		    
		    ret.Value("$Type")= "Object2D"
		    ToJSONDataDefaults shape, ret
		    
		  End If
		  
		  Return ret
		  
		Exception e As JSONException
		  
		  System.DebugLog CurrentMethodName+ "JSONError:"+ e.Message
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub ToJSONDataDefaults(shape As Object2D, shapeJson As JSONData)
		  If shape.BorderColor<> &c00000000 Then shapeJson.Value("BorderColor")= shape.BorderColor.ToHex
		  If shape.Border<> 0 Then shapeJson.Value("Border")= shape.Border
		  If shape.BorderWidth<> 1 Then shapeJson.Value("BorderWidth")= shape.BorderWidth
		  If shape.FillColor<> &c00000000 Then shapeJson.Value("FillColor")= shape.FillColor.ToHex
		  If shape.Fill<> 0 Then shapeJson.Value("Fill")= shape.Fill
		  If shape.Scale<> 1 Then shapeJson.Value("Scale")= shape.Scale
		  If shape.Rotation<> 0 Then shapeJson.Value("Rotation")= shape.Rotation
		  If shape.X<> 0 Then shapeJson.Value("X")= shape.X
		  If shape.Y<> 0 Then shapeJson.Value("Y")= shape.Y
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString(Extends obj As Object2D, compact As Boolean = True) As String
		  Return obj.ToJSONData(compact).ToString
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mPicString As Picture
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  If mPicString= Nil Then mPicString= New Picture(1, 1, 32)
			  
			  return mPicString
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mPicString = value
			End Set
		#tag EndSetter
		Private PicString As Picture
	#tag EndComputedProperty


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
End Module
#tag EndModule
