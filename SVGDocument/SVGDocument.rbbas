#tag Class
Protected Class SVGDocument
Inherits XMLDocument
	#tag Method, Flags = &h21
		Private Sub AddCircle(grp As Group2D, node As XmlElement)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  Dim hasUrl As Boolean= SetStyleUrl(grp, node)
		  
		  If matrix.Ubound= -1 Then
		    Dim shape As New OvalShape
		    shape.Width= node.GetAttribute("r").ParseUnits* 2
		    shape.Height= node.GetAttribute("r").ParseUnits* 2
		    shape.X= node.GetAttribute("cx").ParseUnits
		    shape.Y= node.GetAttribute("cy").ParseUnits
		    
		    SetStyleRecursive shape, node
		    If hasUrl Then shape.Fill= 0
		    
		    grp.Append shape
		    
		    SetStyleMask grp, node
		    
		    RaiseEvent Object2DAdded(shape, node)
		  Else
		    Dim shapeTmp As New CurveShape
		    SetStyleRecursive shapeTmp, node
		    If hasUrl Then shapeTmp.Fill= 0
		    
		    Dim shape As Group2D= Shape2D.Oval(node.GetAttribute("cx").ParseUnits, node.GetAttribute("cx").ParseUnits, _
		    node.GetAttribute("r").ParseUnits, matrix, shapeTmp)
		    
		    If shape.Count> 0 Then
		      grp.Append shape
		      
		      SetStyleMask grp, node
		      
		      RaiseEvent Object2DAdded(shape, node)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddEllipse(grp As Group2D, node As XmlElement)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  Dim hasUrl As Boolean= SetStyleUrl(grp, node)
		  
		  If matrix.Ubound= -1 Then
		    Dim shape As New OvalShape
		    shape.Width= node.GetAttribute("rx").ParseUnits* 2
		    shape.Height= node.GetAttribute("ry").ParseUnits* 2
		    shape.X= node.GetAttribute("cx").ParseUnits
		    shape.Y= node.GetAttribute("cy").ParseUnits
		    
		    SetStyleRecursive shape, node
		    If hasUrl Then shape.Fill= 0
		    
		    grp.Append shape
		    
		    SetStyleMask grp, node
		    
		    RaiseEvent Object2DAdded(shape, node)
		  Else
		    Dim shapeTmp As New CurveShape
		    SetStyleRecursive shapeTmp, node
		    If hasUrl Then shapeTmp.Fill= 0
		    
		    Dim shape As Group2D= Shape2D.Oval(node.GetAttribute("cx").ParseUnits, node.GetAttribute("cx").ParseUnits, _
		    node.GetAttribute("rx").ParseUnits, node.GetAttribute("ry").ParseUnits, matrix, shapeTmp)
		    
		    If shape.Count> 0 Then
		      grp.Append shape
		      
		      SetStyleMask grp, node
		      
		      RaiseEvent Object2DAdded(shape, node)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddGroup(grp As Group2D, node As XmlElement)
		  Dim grpChild As New Group2D
		  
		  For i As Integer= 0 To node.ChildCount- 1
		    If Not (node.Child(i) IsA XmlElement) Then Continue
		    Dim nodeChild As XmlElement= XmlElement(node.Child(i))
		    AddObject2D grpChild, nodeChild
		  Next
		  
		  If grpChild.Count> 0 Then
		    grp.Append grpChild
		    
		    RaiseEvent Object2DAdded(grp, node)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddImage(grp As Group2D, node As XmlElement)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If matrix.Ubound= -1 Then
		    Dim shape As New PixmapShape(ParseImage(node.GetAttribute("xlink:href")))
		    shape.X= node.GetAttribute("x").ParseUnits+ shape.SourceWidth/ 2
		    shape.Y= node.GetAttribute("y").ParseUnits+ shape.SourceHeight/ 2
		    
		    SetStyleRecursive shape, node
		    grp.Append shape
		    
		    RaiseEvent Object2DAdded(shape, node)
		  Else
		    Dim shape As New PixmapShape(ParseImage(node.GetAttribute("xlink:href")))
		    Dim pntA As PointS
		    
		    Dim matrixM() As Double= GetMatrixRecursive(node, "m")
		    If matrixM(0)<> 1 Or matrixM(1)<> 0 Or matrixM(2)<> 0 Or matrixM(3)<> 0 Or matrixM(4)<> 1 Or _
		      matrixM(5)<> 0 Then
		      pntA= TransformPoint(node.GetAttribute("x").ParseUnits, node.GetAttribute("y").ParseUnits, matrix)
		    Else
		      Dim matrixT() As Double= GetMatrixRecursive(node, "t")
		      pntA= TransformPoint(node.GetAttribute("x").ParseUnits, node.GetAttribute("y").ParseUnits, matrixT)
		    End If
		    
		    shape.X= pntA.X+ shape.SourceWidth/ 2
		    shape.Y= pntA.Y+ shape.SourceHeight/ 2
		    
		    // rotate
		    Dim values() As Double= GetTransformRotateRecursive(node)
		    Dim angle, cx, cy As Double
		    For i As Integer= 0 To values.Ubound Step 3
		      angle= values(i)
		      If (i+ 1)<= values.Ubound Then cx= values(i+ 1)
		      If (i+ 2)<= values.Ubound Then cy= values(i+ 2)
		    Next
		    shape.Rotation= Shape2D.ToRadians(angle)
		    If cx> 0 Then shape.X= pntA.X+ (pntA.X- cx)
		    If cy> 0 Then shape.Y= pntA.Y+ (pntA.Y- cy)
		    // rotate
		    
		    // scale
		    Dim matrixS() As Double= GetMatrixRecursive(node, "s")
		    Dim scale As Double= (matrixS(0)+ matrixS(4))/ 2
		    shape.Scale= scale
		    // scale
		    
		    SetStyleRecursive shape, node
		    grp.Append shape
		    
		    RaiseEvent Object2DAdded(shape, node)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddLine(grp As Group2D, node As XmlElement)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  Dim line As New CurveShape
		  line.Border= 1.5
		  
		  If matrix.Ubound= -1 Then
		    line.X= node.GetAttribute("x1").ParseUnits
		    line.Y= node.GetAttribute("y1").ParseUnits
		    line.X2= node.GetAttribute("x2").ParseUnits
		    line.Y2= node.GetAttribute("y2").ParseUnits
		  Else
		    Dim x, y, x2, y2 As Double
		    
		    x= node.GetAttribute("x1").ParseUnits
		    y= node.GetAttribute("y1").ParseUnits
		    x2= node.GetAttribute("x2").ParseUnits
		    y2= node.GetAttribute("y2").ParseUnits
		    
		    TransformPoint x, y, matrix
		    TransformPoint x2, y2, matrix
		    
		    line.X= x
		    line.Y= y
		    line.X2= x2
		    line.Y2= y2
		  End If
		  
		  SetStyleRecursive line, node
		  grp.Append line
		  
		  Dim pnt1 As New PointS(line.X, line.Y)
		  Dim pnt2 As New PointS(line.X2, line.Y2)
		  
		  Dim angle1 As Double= ATan2(line.Y2- line.Y, line.X2- line.X)
		  
		  AddMarkers grp, node, pnt1, pnt2, angle1, angle1
		  
		  RaiseEvent Object2DAdded(line, node)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddMarkers(grp As Group2D, node As XmlElement, pnt1 As PointS, pnt2 As PointS, angle1 As Double = 0, angle2 As Double = 0)
		  If node.GetSubAttribute("style", "marker-start")<> "" Then
		    Dim urlMarker As String= node.GetSubAttribute("style", "marker-start")
		    Dim mark As XmlElement= GetDefinitionByID(ParseURL(urlMarker))
		    
		    If mark<> Nil Then
		      Dim shape As Group2D= GetMarker(mark)
		      shape.RotateItems angle1
		      shape.X= pnt1.X- mark.GetAttribute("refX").ParseUnits
		      shape.Y= pnt1.Y- mark.GetAttribute("refY").ParseUnits
		      
		      If shape.Count> 0 Then grp.Append shape
		    End If
		  End If
		  
		  If node.GetSubAttribute("style", "marker-end")<> "" Then
		    Dim urlMarker As String= node.GetSubAttribute("style", "marker-end")
		    Dim mark As XmlElement= GetDefinitionByID(ParseURL(urlMarker))
		    
		    If mark<> Nil Then
		      Dim shape As Group2D= GetMarker(mark)
		      shape.RotateItems angle2
		      shape.X= pnt2.X//- mark.GetAttribute("refX").ParseUnits
		      shape.Y= pnt2.Y//- mark.GetAttribute("refY").ParseUnits
		      
		      If shape.Count> 0 Then grp.Append shape
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddObject2D(shape As Group2D, node As XmlElement)
		  // sanity chk
		  If node= Nil Then Return
		  
		  Select Case node.Name
		  Case kXmlTagCircle
		    AddCircle shape, node
		  Case kXmlTagEllipse
		    AddEllipse shape, node
		  Case kXmlTagGroup
		    AddGroup shape, node
		  Case kXmlTagImage
		    AddImage shape, node
		  Case kXmlTagLine
		    AddLine shape, node
		  Case kXmlTagPath
		    AddPath shape, node
		  Case kXmlTagPolygon
		    AddPolygon shape, node
		  Case kXmlTagPolyline
		    AddPolyline shape, node
		  Case kXmlTagRect
		    AddRect shape, node
		  Case kXmlTagSvg
		    AddSvg shape, node
		  Case kXmlTagText
		    AddText shape, node
		  Case kXmlTagUse
		    AddUse shape, node
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPath(shape As Group2D, node As XmlElement)
		  Dim draw As String= node.GetAttribute("d")
		  Dim draws() As String= ParseDraw(draw)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  Dim shapePath As New Group2D
		  
		  AddPath shapePath, node, draws, matrix
		  
		  shape.Append shapePath
		  
		  RaiseEvent Object2DAdded(shapePath, node)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPath(shape As Group2D, node As XmlElement, draws() As String, matrix() As Double)
		  #pragma BackgroundTasks False
		  
		  Const Debug= False // to debug
		  
		  Dim shapes() As FigureShape
		  Dim currShape As Integer= -1
		  
		  Dim pnt1 As New PointS
		  Dim x1prev, y1prev As Double
		  Dim isClosedPath As Boolean
		  
		  Dim shapeStyle As New Object2D
		  SetStyleRecursive shapeStyle, node
		  
		  Dim markerPoint1, markerPoint2 As PointS
		  Dim markerAngle1, markerAngle2 As Double
		  
		  For i As Integer= 0 To draws.Ubound
		    Dim cmnd As String= draws(i)
		    Dim c As String= cmnd.Left(1)
		    
		    If Asc(c)= Asc("M") Or Asc(c)= Asc("m") Then // ini close path
		      isClosedPath= ClosedPath(draws, i, node) // chk closed/open path
		      
		      If isClosedPath Then
		        If currShape> -1 Then
		          If shapes(currShape).Count> 0 Then shape.Append shapes(currShape)
		        End If
		        
		        shapes.Append New FigureShape
		        currShape= shapes.Ubound
		        shapes(currShape).CopyStyleFrom shapeStyle
		      End If
		    End If
		    
		    If InStr("csqt", c.Lowercase)= 0 Then // ini previous control point
		      x1prev= 0
		      y1prev= 0
		    End If
		    
		    If Asc(c)= Asc("M") Then
		      // M
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 2
		        If j= 0 Then // 1st point
		          pnt1.X= points(j)
		          If (j+ 1)<= points.Ubound Then pnt1.Y= points(j+ 1)
		          
		          If markerPoint1 Is Nil Then markerPoint1= TransformPoint(pnt1, matrix)
		          
		          If Debug Then DebugLog "M:"+ pnt1.ToString
		        Else // line??
		          Dim pnt2 As New PointS
		          pnt2.X= points(j)
		          If (j+ 1)<= points.Ubound Then pnt2.Y= points(j+ 1)
		          
		          AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		          
		          If Debug Then DebugLog "M lineTo:"+ pnt1.ToString+ " To="+ pnt2.ToString
		          
		          markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		          
		          pnt1= pnt2.Clone
		        End If
		      Next
		      // M
		    ElseIf Asc(c)= Asc("m") Then
		      // m
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 2
		        If j= 0 Then // 1st point
		          pnt1.X= pnt1.X+ points(j)
		          If (j+ 1)<= points.Ubound Then pnt1.Y= pnt1.Y+ points(j+ 1)
		          
		          If markerPoint1 Is Nil Then markerPoint1= TransformPoint(pnt1, matrix)
		          
		          If Debug Then DebugLog "m:"+ pnt1.ToString
		        Else // line??
		          Dim pnt2 As New PointS
		          pnt2.X= pnt1.X+ points(j)
		          If (j+ 1)<= points.Ubound Then pnt2.Y= pnt1.Y+ points(j+ 1)
		          
		          AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		          
		          If Debug Then DebugLog "m lineTo:"+ pnt1.ToString+ " To="+ pnt2.ToString
		          
		          markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		          
		          pnt1= pnt2.Clone
		        End If
		      Next
		      // m
		    ElseIf Asc(c)= Asc("L") Then
		      // L
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound
		        Dim pnt2 As PointS= points(j)
		        
		        AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		        
		        If Debug Then DebugLog "L:"+ pnt1.ToString+ " To="+ pnt2.ToString
		        
		        markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		        
		        pnt1= pnt2.Clone
		      Next
		      // L
		    ElseIf Asc(c)= Asc("l") Then
		      // l
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound
		        Dim pnt2 As PointS= New PointS(pntT.X+ points(j).X, pntT.Y+ points(j).Y)
		        
		        AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		        
		        If Debug Then DebugLog "l:"+ pntT.ToString+ " To="+ pnt2.ToString
		        
		        pntT= pnt2.Clone
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // l
		    ElseIf Asc(c)= Asc("H") Then
		      // H
		      Dim value As Double= cmnd.Mid(2).ParseUnits
		      Dim pnt2 As New PointS(value, pnt1.Y)
		      
		      AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		      
		      If Debug Then DebugLog "H:"+ pnt1.ToString+ " x="+ Str(value)
		      
		      markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		      
		      pnt1.X= value
		      // H
		    ElseIf Asc(c)= Asc("h") Then
		      // h
		      Dim value As Double= pnt1.X+ cmnd.Mid(2).ParseUnits
		      Dim pnt2 As New PointS(value, pnt1.Y)
		      
		      AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		      
		      If Debug Then DebugLog "h:"+ pnt1.ToString+ " x="+ Str(value)
		      
		      markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		      
		      pnt1.X= value
		      // h
		    ElseIf Asc(c)= Asc("V") Then
		      // V
		      Dim value As Double= cmnd.Mid(2).ParseUnits
		      Dim pnt2 As New PointS(pnt1.X, value)
		      
		      AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		      
		      If Debug Then DebugLog "V:"+ pnt1.ToString+ " y="+ Str(value)
		      
		      markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		      
		      pnt1.Y= value
		      // V
		    ElseIf Asc(c)= Asc("v") Then
		      // v
		      Dim value As Double= pnt1.Y+ cmnd.Mid(2).ParseUnits
		      Dim pnt2 As New PointS(pnt1.X, value)
		      
		      AddPathLine isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2
		      
		      If Debug Then DebugLog "v:"+ pnt1.ToString+ " y="+ Str(value)
		      
		      markerAngle2= ATan2(pnt2.Y- pnt1.Y, pnt2.X- pnt1.X)
		      
		      pnt1.Y= value
		      // v
		    ElseIf Asc(c)= Asc("C") Then
		      // C
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 6
		        Dim x1, y1, x2, y2, x, y As Double
		        x1= points(j)
		        If (j+ 1)<= points.Ubound Then y1= points(j+ 1)
		        If (j+ 2)<= points.Ubound Then x2= points(j+ 2)
		        If (j+ 3)<= points.Ubound Then y2= points(j+ 3)
		        If (j+ 4)<= points.Ubound Then x= points(j+ 4)
		        If (j+ 5)<= points.Ubound Then y= points(j+ 5)
		        
		        AddPathCubic isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, x1, y1, x2, y2, x, y
		        
		        If Debug Then DebugLog "C:"+ pnt1.ToString+ " x1="+ Str(x1)+ " y1="+ Str(y1)+ " x2="+ Str(x2)+ " y2="+ Str(y2)+ _
		        " x="+ Str(x)+ " y="+  Str(y)
		        
		        markerAngle2= ATan2(y- pnt1.Y, x- pnt1.X)
		        
		        pnt1.X= x
		        pnt1.Y= y
		        
		        x1prev= x2
		        y1prev= y2
		      Next
		      // C
		    ElseIf Asc(c)= Asc("c") Then
		      // c
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 6
		        Dim x1, y1, x2, y2, x, y As Double
		        x1= pntT.X+ points(j)
		        If (j+ 1)<= points.Ubound Then y1= pntT.Y+ points(j+ 1)
		        If (j+ 2)<= points.Ubound Then x2= pntT.X+ points(j+ 2)
		        If (j+ 3)<= points.Ubound Then y2= pntT.Y+ points(j+ 3)
		        If (j+ 4)<= points.Ubound Then x= pntT.X+ points(j+ 4)
		        If (j+ 5)<= points.Ubound Then y= pntT.Y+ points(j+ 5)
		        
		        AddPathCubic isClosedPath, shape, shapes, shapeStyle, matrix, pntT, x1, y1, x2, y2, x, y
		        
		        If Debug Then DebugLog "c:"+ pntT.ToString+ " x1="+ Str(x1)+ " y1="+ Str(y1)+ " x2="+ Str(x2)+ " y2="+ Str(y2)+ _
		        " x="+ Str(x)+ " y="+  Str(y)
		        
		        pntT.X= x
		        pntT.Y= y
		        
		        x1prev= x2
		        y1prev= y2
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // c
		    ElseIf Asc(c)= Asc("S") Then
		      // S
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 4
		        Dim x2, y2, x, y As Double
		        x2= points(j)
		        If (j+ 1)<= points.Ubound Then y2= points(j+ 1)
		        If (j+ 2)<= points.Ubound Then x= points(j+ 2)
		        If (j+ 3)<= points.Ubound Then y= points(j+ 3)
		        Dim x1 As Double= ReflectionValue(pnt1.X, x1prev)
		        Dim y1 As Double= ReflectionValue(pnt1.Y, y1prev)
		        
		        AddPathCubic isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, x1, y1, x2, y2, x, y
		        
		        If Debug Then DebugLog "S:"+ pnt1.ToString+ " x1="+ Str(x1)+ " y1="+ Str(y1)+ " x2="+ Str(x2)+ " y2="+ Str(y2)+ _
		        " x="+ Str(x)+ " y="+  Str(y)
		        
		        markerAngle2= ATan2(y- pnt1.Y, x- pnt1.X)
		        
		        pnt1.X= x
		        pnt1.Y= y
		        
		        x1prev= x2
		        y1prev= y2
		      Next
		      // S
		    ElseIf Asc(c)= Asc("s") Then
		      // s
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 4
		        Dim x2, y2, x, y As Double
		        x2= pntT.X+ points(j)
		        If (j+ 1)<= points.Ubound Then y2= pntT.Y+ points(j+ 1)
		        If (j+ 2)<= points.Ubound Then x= pntT.X+ points(j+ 2)
		        If (j+ 3)<= points.Ubound Then y= pntT.Y+ points(j+ 3)
		        Dim x1 As Double= ReflectionValue(pntT.X, x1prev)
		        Dim y1 As Double= ReflectionValue(pntT.Y, y1prev)
		        
		        AddPathCubic isClosedPath, shape, shapes, shapeStyle, matrix, pntT, x1, y1, x2, y2, x, y
		        
		        If Debug Then DebugLog "s:"+ pntT.ToString+ " x1="+ Str(x1)+ " y1="+ Str(y1)+ " x2="+ Str(x2)+ " y2="+ Str(y2)+ _
		        " x="+ Str(x)+ " y="+  Str(y)
		        
		        pntT.X= x
		        pntT.Y= y
		        
		        x1prev= x2
		        y1prev= y2
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // s
		    ElseIf Asc(c)= Asc("Q") Then
		      // Q
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound Step 2
		        Dim pnt2 As PointS= points(j)
		        Dim pnt3 As New PointS
		        If (j+ 1)<= points.Ubound Then pnt3= points(j+ 1)
		        
		        AddPathQuad isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2, pnt3
		        
		        markerAngle2= ATan2(pnt3.Y- pnt1.Y, pnt3.X- pnt1.X)
		        
		        pnt1= pnt3.Clone
		        
		        x1prev= pnt2.X
		        y1prev= pnt2.Y
		      Next
		      // Q
		    ElseIf Asc(c)= Asc("q") Then
		      // q
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound Step 2
		        Dim pnt2 As PointS= New PointS(pntT.X+ points(j).X, pntT.Y+ points(j).Y)
		        Dim pnt3 As New PointS
		        If (j+ 1)<= points.Ubound Then pnt3= New PointS(pntT.X+ points(j+ 1).X, pntT.Y+ points(j+ 1).Y)
		        
		        AddPathQuad isClosedPath, shape, shapes, shapeStyle, matrix, pntT, pnt2, pnt3
		        
		        pntT= pnt3.Clone
		        
		        x1prev= pnt2.X
		        y1prev= pnt2.Y
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // q
		    ElseIf Asc(c)= Asc("T") Then
		      // T
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound
		        Dim pnt3 As PointS= points(j)
		        Dim pnt2 As New PointS(ReflectionValue(pnt1.X, x1prev), ReflectionValue(pnt1.Y, y1prev))
		        
		        AddPathQuad isClosedPath, shape, shapes, shapeStyle, matrix, pnt1, pnt2, pnt3
		        
		        markerAngle2= ATan2(pnt3.Y- pnt1.Y, pnt3.X- pnt1.X)
		        
		        pnt1= pnt3.Clone
		        
		        x1prev= pnt2.X
		        y1prev= pnt2.Y
		      Next
		      // T
		    ElseIf Asc(c)= Asc("t") Then
		      // t
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As PointS= ParseDrawPoints(cmnd)
		      For j As Integer= 0 To points.Ubound
		        Dim pnt3 As PointS= New PointS(pntT.X+ points(j).X, pntT.Y+ points(j).Y)
		        Dim pnt2 As New PointS(ReflectionValue(pntT.X, x1prev), ReflectionValue(pntT.Y, y1prev))
		        
		        AddPathQuad isClosedPath, shape, shapes, shapeStyle, matrix, pntT, pnt2, pnt3
		        
		        pntT= pnt3.Clone
		        
		        x1prev= pnt2.X
		        y1prev= pnt2.Y
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // t
		    ElseIf Asc(c)= Asc("A") Then
		      // A
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 7
		        Dim rx, ry, x, y As Double
		        Dim theta, flagA, flagS As Integer
		        rx= points(j)
		        If (j+ 1)<= points.Ubound Then ry= points(j+ 1)
		        If (j+ 2)<= points.Ubound Then theta= points(j+ 2)
		        If (j+ 3)<= points.Ubound Then flagA= points(j+ 3)
		        If (j+ 4)<= points.Ubound Then flagS= points(j+ 4)
		        If (j+ 5)<= points.Ubound Then x= points(j+ 5)
		        If (j+ 6)<= points.Ubound Then y= points(j+ 6)
		        
		        If isClosedPath Then
		          If matrix.Ubound= -1 Then
		            Shape2D.EllipticalArcFill shapes(currShape), pnt1.X, pnt1.Y, rx, ry, theta, flagA, flagS, x, y
		          Else
		            Shape2D.EllipticalArcFill shapes(currShape), pnt1.X, pnt1.Y, rx, ry, theta, flagA, flagS, x, y, matrix
		          End If
		        Else // openpath
		          Dim line As Group2D
		          If matrix.Ubound= -1 Then
		            line= Shape2D.EllipticalArc(pnt1.X, pnt1.Y, rx, ry, theta, flagA, flagS, x, y, _
		            shapeStyle.BorderColor, shapeStyle.BorderWidth, shapeStyle.Border)
		          Else
		            line= Shape2D.EllipticalArc(pnt1.X, pnt1.Y, rx, ry, theta, flagA, flagS, x, y, _
		            shapeStyle.BorderColor, shapeStyle.BorderWidth, shapeStyle.Border, matrix)
		          End If
		          
		          shape.Append line
		        End If // openpath
		        
		        markerAngle2= ATan2(y- pnt1.Y, x- pnt1.X)
		        
		        pnt1.X= x
		        pnt1.Y= y
		      Next
		      // A
		    ElseIf Asc(c)= Asc("a") Then
		      // a
		      Dim pntT As PointS= pnt1.Clone
		      Dim points() As Double= ParseDrawValues(cmnd)
		      For j As Integer= 0 To points.Ubound Step 7
		        Dim rx, ry, x, y As Double
		        Dim theta, flagA, flagS As Integer
		        rx= points(j)
		        If (j+ 1)<= points.Ubound Then ry= points(j+ 1)
		        If (j+ 2)<= points.Ubound Then theta= points(j+ 2)
		        If (j+ 3)<= points.Ubound Then flagA= points(j+ 3)
		        If (j+ 4)<= points.Ubound Then flagS= points(j+ 4)
		        If (j+ 5)<= points.Ubound Then x= pntT.X+ points(j+ 5)
		        If (j+ 6)<= points.Ubound Then y= pntT.Y+ points(j+ 6)
		        
		        If isClosedPath Then
		          If matrix.Ubound= -1 Then
		            Shape2D.EllipticalArcFill shapes(currShape), pntT.X, pntT.Y, rx, ry, theta, flagA, flagS, x, y
		          Else
		            Shape2D.EllipticalArcFill shapes(currShape), pntT.X, pntT.Y, rx, ry, theta, flagA, flagS, x, y, matrix
		          End If
		        Else // openpath
		          Dim line As New Group2D
		          If matrix.Ubound= -1 Then
		            line= Shape2D.EllipticalArc(pntT.X, pntT.Y, rx, ry, theta, flagA, flagS, x, y, _
		            shapeStyle.BorderColor, shapeStyle.BorderWidth, shapeStyle.Border)
		          Else
		            line= Shape2D.EllipticalArc(pntT.X, pntT.Y, rx, ry, theta, flagA, flagS, x, y, _
		            shapeStyle.BorderColor, shapeStyle.BorderWidth, shapeStyle.Border, matrix)
		          End If
		          
		          shape.Append line
		        End If // openpath
		        
		        pntT.X= x
		        pntT.Y= y
		      Next
		      
		      markerAngle2= ATan2(pntT.Y- pnt1.Y, pntT.X- pnt1.X)
		      
		      pnt1= pntT.Clone
		      // a
		    End If
		    
		    'If c.Lowercase<> "z" Then DebugLog shapes(currShape), 0, 0, .5, 1200, 400
		    
		  Next
		  
		  If markerPoint2 Is Nil Then markerPoint2= TransformPoint(pnt1, matrix)
		  
		  If isClosedPath Then // chk for last path
		    If currShape> -1 Then
		      If shapes(currShape).Count> 0 Then shape.Append shapes(currShape)
		    End If
		  End If
		  
		  // fill-rule
		  Dim found As Boolean
		  
		  For i As Integer= 0 To shapes.Ubound
		    If shapes(i).Count> 0 Then
		      
		      If i> 0 And shapes(0).Contains(shapes(i)) Then
		        shapes(i).Border= 0
		        shapes(i).Fill= 100
		        shapes(i).FillColor= Shape2D.GetContrastColor(shapes(0).FillColor, &c2A2A2A00, &cFBFBFB00)
		        
		        found= True
		      End If
		    End If
		  Next
		  
		  If Not found Then
		    Dim n As Integer= shapes.Ubound
		    For i As Integer= n DownTo 0
		      If shapes(i).Count> 0 Then
		        If i< n And shapes(n).Contains(shapes(i)) Then
		          shapes(n).Border= 100
		          shapes(n).Fill= 0
		          shapes(i).Border= 100
		          shapes(i).Fill= 0
		          'shapes(i).FillColor= Shape2D.GetContrastColor(shapes(n).FillColor, &c2A2A2A00, &cFBFBFB00)
		        End If
		      End If
		    Next
		  End If
		  // fill-rule
		  
		  AddMarkers shape, node, markerPoint1, markerPoint2, markerAngle1, markerAngle2
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPathCubic(isClosedPath As Boolean, shape As Group2D, shapes() As FigureShape, shapeStyle As Object2D, matrix() As Double, pnt1 As PointS, x1 As Double, y1 As Double, x2 As Double, y2 As Double, x As Double, y As Double)
		  If isClosedPath Then
		    If matrix.Ubound= -1 Then
		      shapes(shapes.Ubound).AddCubic pnt1.X, pnt1.Y, x, y, x1, y1, x2, y2
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(x, y, matrix)
		      Dim pnt1a As PointS= TransformPoint(x1, y1, matrix)
		      Dim pnt2 As PointS= TransformPoint(x2, y2, matrix)
		      shapes(shapes.Ubound).AddCubic pntA.X, pntA.Y, pntB.X, pntB.Y, pnt1a.X, pnt1a.Y, pnt2.X, pnt2.Y
		    End If
		  Else // openpath
		    Dim line As New CurveShape
		    line.Order= 2
		    If matrix.Ubound= -1 Then
		      line.X= pnt1.X
		      line.Y= pnt1.Y
		      line.X2= x
		      line.Y2= y
		      line.ControlX(0)= x1
		      line.ControlY(0)= y1
		      line.ControlX(1)= x2
		      line.ControlY(1)= y2
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(x, y, matrix)
		      Dim pnt1a As PointS= TransformPoint(x1, y1, matrix)
		      Dim pnt2 As PointS= TransformPoint(x2, y2, matrix)
		      
		      line.X= pntA.X
		      line.Y= pntA.Y
		      line.X2= pntB.X
		      line.Y2= pntB.Y
		      line.ControlX(0)= pnt1a.X
		      line.ControlY(0)= pnt1a.Y
		      line.ControlX(1)= pnt2.X
		      line.ControlY(1)= pnt2.Y
		    End If
		    
		    line.CopyStyleFrom shapeStyle
		    shape.Append line
		  End If // openpath
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPathLine(isClosedPath As Boolean, shape As Group2D, shapes() As FigureShape, shapeStyle As Object2D, matrix() As Double, pnt1 As PointS, pnt2 As PointS)
		  If isClosedPath Then
		    If matrix.Ubound= -1 Then
		      shapes(shapes.Ubound).AddLine pnt1.X, pnt1.Y, pnt2.X, pnt2.Y
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(pnt2.X, pnt2.Y, matrix)
		      shapes(shapes.Ubound).AddLine pntA.X, pntA.Y, pntB.X, pntB.Y
		    End If
		  Else // openpath
		    Dim line As New CurveShape
		    If matrix.Ubound= -1 Then
		      line.X= pnt1.X
		      line.Y= pnt1.Y
		      line.X2= pnt2.X
		      line.Y2= pnt2.Y
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(pnt2.X, pnt2.Y, matrix)
		      
		      line.X= pntA.X
		      line.Y= pntA.Y
		      line.X2= pntB.X
		      line.Y2= pntB.Y
		    End If
		    
		    line.CopyStyleFrom shapeStyle
		    shape.Append line
		  End If // openpath
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPathQuad(isClosedPath As Boolean, shape As Group2D, shapes() As FigureShape, shapeStyle As Object2D, matrix() As Double, pnt1 As PointS, pnt2 As PointS, pnt3 As PointS)
		  If isClosedPath Then
		    If matrix.Ubound= -1 Then
		      shapes(shapes.Ubound).AddQuad pnt1.X, pnt1.Y, pnt3.X, pnt3.Y, pnt2.X, pnt2.Y
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(pnt3.X, pnt3.Y, matrix)
		      Dim pntC As PointS= TransformPoint(pnt2.X, pnt2.Y, matrix)
		      shapes(shapes.Ubound).AddQuad pntA.X, pntA.Y, pntB.X, pntB.Y, pntC.X, pntC.Y
		    End If
		  Else // openpath
		    Dim line As New CurveShape
		    line.Order= 1
		    If matrix.Ubound= -1 Then
		      line.X= pnt1.X
		      line.Y= pnt1.Y
		      line.X2= pnt3.X
		      line.Y2= pnt3.Y
		      line.ControlX(0)= pnt2.X
		      line.ControlY(0)= pnt2.Y
		    Else
		      Dim pntA As PointS= TransformPoint(pnt1.X, pnt1.Y, matrix)
		      Dim pntB As PointS= TransformPoint(pnt3.X, pnt3.Y, matrix)
		      Dim pntC As PointS= TransformPoint(pnt2.X, pnt2.Y, matrix)
		      
		      line.X= pntA.X
		      line.Y= pntA.Y
		      line.X2= pntB.X
		      line.Y2= pntB.Y
		      line.ControlX(0)= pntC.X
		      line.ControlY(0)= pntC.Y
		    End If
		    
		    line.CopyStyleFrom shapeStyle
		    shape.Append line
		  End If // openpath
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPolygon(grp As Group2D, node As XmlElement)
		  Dim shape As New FigureShape
		  
		  Dim points() As PointS= ParsePoints(node.GetAttribute("points"))
		  
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If matrix.Ubound= -1 Then
		    If points.Ubound> 0 Then
		      For i As Integer= 1 To points.Ubound
		        Dim point1 As PointS= points(i- 1)
		        Dim point2 As New PointS
		        If i<= points.Ubound Then point2= points(i)
		        
		        shape.AddLine point1.X, point1.Y, point2.X, point2.Y
		      Next
		    End If
		  Else
		    If points.Ubound> 0 Then
		      For i As Integer= 1 To points.Ubound
		        Dim point1 As PointS= points(i- 1)
		        Dim point2 As New PointS
		        If i<= points.Ubound Then point2= points(i)
		        
		        Dim x1, y1, x2, y2 As Double
		        
		        x1= point1.X
		        y1= point1.Y
		        x2= point2.X
		        y2= point2.Y
		        
		        TransformPoint x1, y1, matrix
		        TransformPoint x2, y2, matrix
		        
		        shape.AddLine x1, y1, x2, y2
		      Next
		    End If
		  End If
		  
		  SetStyleRecursive shape, node
		  grp.Append shape
		  
		  RaiseEvent Object2DAdded(shape, node)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddPolyline(grp As Group2D, node As XmlElement)
		  Dim shape As New Group2D
		  Dim points() As PointS= ParsePoints(node.GetAttribute("points"))
		  
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If matrix.Ubound= -1 Then
		    If points.Ubound> 0 Then
		      For i As Integer= 1 To points.Ubound
		        Dim point1 As PointS= points(i- 1)
		        Dim point2 As New PointS
		        If i<= points.Ubound Then point2= points(i)
		        
		        Dim line As New CurveShape
		        line.Border= 1.5
		        line.X= point1.X
		        line.Y= point1.Y
		        line.X2= point2.X
		        line.Y2= point2.Y
		        
		        SetStyleRecursive line, node
		        shape.Append line
		      Next
		    End If
		  Else
		    If points.Ubound> 0 Then
		      For i As Integer= 1 To points.Ubound
		        Dim point1 As PointS= points(i- 1)
		        Dim point2 As New PointS
		        If i<= points.Ubound Then point2= points(i)
		        
		        Dim x, y, x2, y2 As Double
		        
		        x= point1.X
		        y= point1.Y
		        x2= point2.X
		        y2= point2.Y
		        
		        TransformPoint x, y, matrix
		        TransformPoint x2, y2, matrix
		        
		        Dim line As New CurveShape
		        line.Border= 1.5
		        line.X= x
		        line.Y= y
		        line.X2= x2
		        line.Y2= y2
		        
		        SetStyleRecursive line, node
		        shape.Append line
		      Next
		    End If
		  End If
		  
		  grp.Append shape
		  
		  RaiseEvent Object2DAdded(shape, node)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddRect(grp As Group2D, node As XmlElement)
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If matrix.Ubound= -1 Then
		    Dim hasUrl As Boolean= SetStyleUrl(grp, node)
		    
		    Dim shape As New RoundRectShape
		    shape.Width= node.GetAttribute("width").ParseUnits
		    shape.Height= node.GetAttribute("height").ParseUnits
		    shape.X= node.GetAttribute("x").ParseUnits+ shape.Width/ 2
		    shape.Y= node.GetAttribute("y").ParseUnits+ shape.Height/ 2
		    
		    SetStyleRecursive shape, node
		    If hasUrl Then shape.Fill= 0
		    
		    grp.Append shape
		    
		    SetStyleMask grp, node
		    
		    RaiseEvent Object2DAdded(shape, node)
		  Else
		    Dim x, y, x2, y2 As Double
		    
		    x= node.GetAttribute("x").ParseUnits
		    y= node.GetAttribute("y").ParseUnits
		    x2= node.GetAttribute("x").ParseUnits+ node.GetAttribute("width").ParseUnits
		    y2= y
		    
		    TransformPoint x, y, matrix
		    TransformPoint x2, y2, matrix
		    
		    Dim shape As New FigureShape
		    shape.AddLine x, y, x2, y2
		    
		    x= x2
		    y= y2
		    x2= node.GetAttribute("x").ParseUnits+ node.GetAttribute("width").ParseUnits
		    y2= node.GetAttribute("y").ParseUnits+ node.GetAttribute("height").ParseUnits
		    
		    TransformPoint x2, y2, matrix
		    shape.AddLine x, y, x2, y2
		    
		    x= x2
		    y= y2
		    x2= node.GetAttribute("x").ParseUnits
		    y2= node.GetAttribute("y").ParseUnits+ node.GetAttribute("height").ParseUnits
		    
		    TransformPoint x2, y2, matrix
		    shape.AddLine x, y, x2, y2
		    
		    SetStyleRecursive shape, node
		    grp.Append shape
		    
		    RaiseEvent Object2DAdded(shape, node)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddSvg(grp As Group2D, node As XmlElement)
		  Dim grpChild As New Group2D
		  
		  For i As Integer= 0 To node.ChildCount- 1
		    If Not (node.Child(i) IsA XmlElement) Then Continue
		    Dim nodeChild As XmlElement= XmlElement(node.Child(i))
		    AddObject2D grpChild, nodeChild
		  Next
		  
		  If grpChild.Count> 0 Then
		    grpChild.X= node.GetAttribute("x").ParseUnits
		    grpChild.Y= node.GetAttribute("y").ParseUnits
		    
		    grp.Append grpChild
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddText(grp As Group2D, node As XmlElement)
		  If node.ChildCount= 0 Then Return
		  
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If node.FirstChild IsA XmlTextNode Then
		    Dim shape As New StringShape
		    shape.Text= node.FirstChild.Value.ReplaceAll(Chr(13), "").ReplaceAll(Chr(10), "").Trim
		    shape.HorizontalAlignment= StringShape.Alignment.Left
		    
		    Dim x As Double= node.GetAttribute("x").ParseUnits
		    Dim y As Double= node.GetAttribute("y").ParseUnits
		    
		    If matrix.Ubound<> -1 Then
		      Dim pntT As PointS= TransformPoint(x, y, matrix)
		      shape.X= pntT.X
		      shape.Y= pntT.Y
		    Else
		      shape.X= x
		      shape.Y= y
		    End If
		    
		    shape.Scale= GetTransformScaleRecursive(node)
		    
		    SetStyleRecursive shape, node
		    SetStyleText shape, node
		    shape.Fill= 100 // fill:none, doesn't work in real
		    
		    grp.Append shape
		    
		    RaiseEvent Object2DAdded(shape, node)
		  Else
		    Dim xWidth As Double
		    
		    For i As Integer= 0 To node.ChildCount- 1
		      If Not (node.Child(i) IsA XmlElement) Then Continue
		      Dim nodeChild As XmlElement= XmlElement(node.Child(i))
		      
		      If nodeChild.FirstChild IsA XmlTextNode Then
		        Dim shape As New StringShape
		        shape.Text= nodeChild.FirstChild.Value.ReplaceAll(Chr(13), "").ReplaceAll(Chr(10), "").Trim
		        shape.HorizontalAlignment= StringShape.Alignment.Left
		        
		        Dim x As Double= nodeChild.GetAttribute("x").ParseUnits
		        If x= 0 Then x= node.GetAttribute("x").ParseUnits
		        Dim y As Double= nodeChild.GetAttribute("y").ParseUnits
		        If y= 0 Then y= node.GetAttribute("y").ParseUnits
		        
		        If matrix.Ubound<> -1 Then
		          Dim pntT As New PointS(x+ xWidth+ nodeChild.GetAttribute("dx").ParseUnits, _
		          y+ nodeChild.GetAttribute("dy").ParseUnits)
		          pntT= TransformPoint(pntT.X, pntT.Y, matrix)
		          shape.X= pntT.X
		          shape.Y= pntT.Y
		        Else
		          shape.X= x+ xWidth+ nodeChild.GetAttribute("dx").ParseUnits
		          shape.Y= y+ nodeChild.GetAttribute("dy").ParseUnits
		        End If
		        
		        shape.Scale= GetTransformScaleRecursive(node)
		        
		        SetStyleRecursive shape, nodeChild
		        SetStyleText shape, node
		        shape.Fill= 100 // fill:none, doesn't work in real
		        
		        grp.Append shape
		        
		        RaiseEvent Object2DAdded(shape, node)
		        
		        xWidth= xWidth+ shape.StringWidth
		      End If
		    Next
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AddUse(grp As Group2D, node As XmlElement)
		  Dim nodeChild As XmlElement= GetDefinitionByID(node.GetAttribute("xlink:href").ReplaceAll("#", ""))
		  If nodeChild<> Nil Then
		    SetTransforms node
		    
		    Dim grpChild As New Group2D
		    
		    AddObject2D grpChild, nodeChild
		    
		    If grpChild.Count> 0 Then
		      grpChild.X= node.GetAttribute("x").ParseUnits
		      grpChild.Y= node.GetAttribute("y").ParseUnits
		      
		      SetStyleRecursive grpChild, nodeChild
		      grp.Append grpChild
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ClosedPath(draws() As String, idx As Integer, node As XmlElement) As Boolean
		  Dim ret As Boolean
		  
		  For i As Integer= idx+ 1 To draws.Ubound
		    Dim c As String= draws(i).Trim.Left(1).LowerCase
		    If Asc(c)= Asc("z") Then
		      Return True
		      'ElseIf Asc(c)= Asc("m") Then
		      'Return False
		    End If
		  Next
		  
		  If HasFillStyleRecursive(node) Then Return True
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ColorFromHex(str As String) As Color
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim result As Color
		  Dim colVariant As Variant
		  Dim tmpStr As String
		  
		  if Left(str, 1) = "#" then
		    tmpStr = Right(str, Len(str) - 1)
		  else
		    tmpStr = str
		  end if
		  
		  if Len(tmpStr) = 3 then
		    tmpStr = Left(tmpStr, 1) + Left(tmpStr, 1) + Mid(tmpStr, 2, 1) + Mid(tmpStr, 2, 1) + Right(tmpStr, 1) + Right(tmpStr, 1)
		  end if
		  
		  tmpStr = "&c" + tmpStr
		  
		  colVariant = tmpStr
		  result = colVariant.ColorValue
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor()
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From XmlDocument
		  // Constructor(xmlDoc As String) -- From XmlDocument
		  // Constructor(fItem As FolderItem) -- From XmlDocument
		  Super.Constructor
		  
		  Init
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(fItem As FolderItem)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From XmlDocument
		  // Constructor(xmlDoc As String) -- From XmlDocument
		  // Constructor(fItem As FolderItem) -- From XmlDocument
		  Try
		    Super.Constructor(fItem)
		  Catch e As XmlException
		    DebugLog CurrentMethodName+ " XmlException: "+ e.Message
		  Catch e As XmlDomException
		    DebugLog CurrentMethodName+ " XmlDomException: "+ e.Message
		  Catch e As XmlReaderException
		    DebugLog CurrentMethodName+ " XmlReaderException: "+ e.Message
		  End Try
		  
		  InitChk
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1000
		Sub Constructor(xmlDoc As String)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From XmlDocument
		  // Constructor(xmlDoc As String) -- From XmlDocument
		  // Constructor(fItem As FolderItem) -- From XmlDocument
		  Try
		    Super.Constructor(xmlDoc)
		  Catch e As XmlException
		    DebugLog CurrentMethodName+ " XmlException: "+ e.Message
		  Catch e As XmlDomException
		    DebugLog CurrentMethodName+ " XmlDomException: "+ e.Message
		  Catch e As XmlReaderException
		    DebugLog CurrentMethodName+ " XmlReaderException: "+ e.Message
		  End Try
		  
		  InitChk
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub DebugLog(shape As Object2D, x As Integer = 0, y As Integer = 0, scale As Double = 2, picWidth As Integer = 800, picHeight As Integer = 600)
		  Dim f As FolderItem= SpecialFolder.Documents.Child("Debug")
		  
		  If f<> Nil And f.Directory Then
		    Static n As Integer
		    n= n+ 1
		    
		    Dim oldScale As Double= shape.Scale
		    shape.Scale= scale
		    
		    Dim p As New Picture(picWidth, picHeight)
		    
		    If shape IsA Group2D Then // RuntimeError when Count= 0, cant capture
		      If Group2D(shape).Count> 0 Then p.Graphics.DrawObject shape, x, y
		    ElseIf shape IsA FigureShape Then // RuntimeError when Count= 0, cant capture
		      If FigureShape(shape).Count> 0 Then p.Graphics.DrawObject shape, x, y
		    Else
		      p.Graphics.DrawObject shape, x, y
		    End If
		    
		    p.Save f.Child("SVGDocument_"+ Str(n, "0000")+ ".png"), Picture.SaveAsPNG
		    
		    shape.Scale= oldScale
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub DebugLog(msg As String)
		  System.DebugLog CurrentMethodName+ msg
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteAllChildren()
		  For i As Integer= 0 To ChildCount- 1
		    RemoveChild Child(i)
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetDefinitionByID(id As String) As XmlElement
		  Dim nodes As XmlNodeList= Self.Xql("//defs")
		  
		  For i As Integer= 0 To nodes.Length- 1
		    Dim node As XmlNode= nodes.Item(i)
		    Try
		      Dim nodesId As XmlNodeList= node.Xql("*[@id = '"+ id+ "']")
		      If nodesId.Length> 0 Then
		        If nodesId.Item(0) IsA XmlElement Then
		          Return XmlElement(nodesId.Item(0))
		        End If
		      End If
		    Catch e As XmlException
		      Return Nil
		    End Try
		  Next
		  
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetMarker(node As XmlElement) As Group2D
		  Dim shape As New Group2D
		  
		  For i As Integer= 0 To node.ChildCount- 1
		    If Not (node.Child(i) IsA XmlElement) Then Continue
		    Dim nodeChild As XmlElement= XmlElement(node.Child(i))
		    AddObject2D shape, nodeChild
		  Next
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetMatrix(node As XmlElement, tTypes As String) As Double()
		  Dim matrix() As Double
		  
		  Dim transform As String= node.GetAttribute("transform")
		  If transform<> "" Then
		    Dim transfrmts() As String= ParseTransformations(transform)
		    Dim matrixI() As Double= Array(_
		    1.0, 0.0, 0.0, _
		    0.0, 1.0, 0.0, _
		    0.0, 0.0, 1.0)
		    
		    For i As Integer= 0 To transfrmts.Ubound
		      Dim trans As String= transfrmts(i)
		      Dim values() As Double= ParseDrawValues(trans)
		      
		      If trans.InStr("translate")> 0 And tTypes.InStr("t")> 0 Then
		        Dim tx, ty As Double
		        For j As Integer= 0 To values.Ubound Step 2
		          tx= values(j)
		          If (j+ 1)<= values.Ubound Then ty= values(j+ 1)
		        Next
		        Dim matrixT() As Double= Array(_
		        1.0, 0.0, tx, _
		        0.0, 1.0, ty, _
		        0.0, 0.0, 1.0)
		        
		        matrixI= MatrixMultiply(matrixI, matrixT)
		      ElseIf trans.InStr("rotate")> 0 And tTypes.InStr("r")> 0 Then
		        Dim angle, cx, cy As Double
		        For j As Integer= 0 To values.Ubound Step 3
		          angle= values(j)
		          If (j+ 1)<= values.Ubound Then cx= values(j+ 1)
		          If (j+ 2)<= values.Ubound Then cy= values(j+ 2)
		        Next
		        If cx<> 0 Or cy<> 0 Then
		          Dim matrixT() As Double= Array(_
		          1.0, 0.0, cx, _
		          0.0, 1.0, cy, _
		          0.0, 0.0, 1.0)
		          matrixI= MatrixMultiply(matrixI, matrixT)
		          
		          Dim matrixR() As Double= Array(_
		          Cos(Shape2D.ToRadians(angle)), -Sin(Shape2D.ToRadians(angle)), 0.0, _
		          Sin(Shape2D.ToRadians(angle)), Cos(Shape2D.ToRadians(angle)), 0.0, _
		          0.0, 0.0, 1.0)
		          matrixI= MatrixMultiply(matrixI, matrixR)
		          
		          matrixT(2)= -cx
		          matrixT(5)= -cy
		          matrixI= MatrixMultiply(matrixI, matrixT)
		        Else
		          Dim matrixR() As Double= Array(_
		          Cos(Shape2D.ToRadians(angle)), -Sin(Shape2D.ToRadians(angle)), 0.0, _
		          Sin(Shape2D.ToRadians(angle)), Cos(Shape2D.ToRadians(angle)), 0.0, _
		          0.0, 0.0, 1.0)
		          matrixI= MatrixMultiply(matrixI, matrixR)
		        End If
		      ElseIf trans.InStr("scale")> 0 And tTypes.InStr("s")> 0 Then
		        Dim sx, sy As Double
		        For j As Integer= 0 To values.Ubound Step 2
		          sx= values(j)
		          sy= sx
		          If (j+ 1)<= values.Ubound Then sy= values(j+ 1)
		        Next
		        Dim matrixS() As Double= Array(_
		        sx, 0.0, 0.0, _
		        0.0, sy, 0.0, _
		        0.0, 0.0, 1.0)
		        
		        matrixI= MatrixMultiply(matrixI, matrixS)
		      ElseIf trans.InStr("skewX")> 0 And tTypes.InStr("x")> 0 Then
		        Dim angle As Double
		        For j As Integer= 0 To values.Ubound
		          angle= values(j)
		        Next
		        Dim matrixK() As Double= Array(_
		        1.0, Tan(Shape2D.ToRadians(angle)), 0.0, _
		        0.0, 1.0, 0.0, _
		        0.0, 0.0, 1.0)
		        
		        matrixI= MatrixMultiply(matrixI, matrixK)
		      ElseIf trans.InStr("skewY")> 0 And tTypes.InStr("y")> 0 Then
		        Dim angle As Double
		        For j As Integer= 0 To values.Ubound
		          angle= values(j)
		        Next
		        Dim matrixK() As Double= Array(_
		        1.0, 0.0, 0.0, _
		        Tan(Shape2D.ToRadians(angle)), 1.0, 0.0, _
		        0.0, 0.0, 1.0)
		        
		        matrixI= MatrixMultiply(matrixI, matrixK)
		      ElseIf trans.InStr("matrix")> 0 And tTypes.InStr("m")> 0 Then
		        Dim a, b, c, d, e, f As Double
		        For j As Integer= 0 To values.Ubound Step 6
		          a= values(j)
		          If (j+ 1)<= values.Ubound Then b= values(j+ 1)
		          If (j+ 2)<= values.Ubound Then c= values(j+ 2)
		          If (j+ 3)<= values.Ubound Then d= values(j+ 3)
		          If (j+ 4)<= values.Ubound Then e= values(j+ 4)
		          If (j+ 5)<= values.Ubound Then f= values(j+ 5)
		        Next
		        Dim matrixM() As Double= Array(_
		        a, c, e, _
		        b, d, f, _
		        0.0, 0.0, 1.0)
		        
		        matrixI= MatrixMultiply(matrixI, matrixM)
		      End If
		      
		    Next
		    matrix= matrixI
		  End If
		  
		  Return matrix
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetMatrixRecursive(node As XmlElement, tTypes As String = "mtsrxy") As Double()
		  Dim matrixNode() As Double= GetMatrix(node, tTypes)
		  
		  Dim matrixNodes() As Pair
		  matrixNodes.Append New Pair(node.Name, matrixNode)
		  
		  Dim parentNode As XmlNode= node.Parent
		  
		  Do
		    If parentNode<> Nil And parentNode IsA XmlElement Then
		      Dim matrixParent() As Double= GetMatrix(XmlElement(parentNode), tTypes)
		      matrixNodes.Append New Pair(parentNode.Name, matrixParent)
		      
		      parentNode= parentNode.Parent
		    End If
		    
		  Loop Until parentNode IsA XmlDocument
		  
		  If matrixNodes.Ubound<> -1 Then // search in dictionary
		    Dim matrixI() As Double= Array(_
		    1.0, 0.0, 0.0, _
		    0.0, 1.0, 0.0, _
		    0.0, 0.0, 1.0)
		    
		    For i As Integer= matrixNodes.Ubound DownTo 0
		      Dim p As Pair= matrixNodes(i)
		      Dim matrixTmp() As Double= p.Right
		      If matrixTmp.Ubound<> -1 Then
		        matrixI= MatrixMultiply(matrixI, matrixTmp)
		        matrixNode= matrixI
		      End If
		    Next
		    
		  End If
		  
		  If matrixNode.Ubound= -1 Then // search in dictionary
		    Dim id As String= node.GetAttribute("id")
		    If mTransforms.HasKey(id) Then
		      Dim matrixTransforms() As Double= mTransforms.Value(id)
		      matrixNode= matrixTransforms
		    End If
		  End If
		  
		  Return matrixNode
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetStyle(selector As String, name As String) As String
		  If selector= "" Or name= "" Then Return ""
		  
		  If mKeysCSS= Nil Then LoadCSS
		  
		  If mKeysCSS.HasKey(selector) Then
		    Dim dValu As Dictionary= mKeysCSS.Value(selector)
		    If dValu.HasKey(name) Then
		      Return dValu.Value(name).StringValue
		    End If
		  End If
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTransformRotate(node As XmlElement) As Double()
		  Dim valuesR() As Double
		  
		  Dim transform As String= node.GetAttribute("transform")
		  If transform<> "" Then
		    Dim transfrmts() As String= ParseTransformations(transform)
		    
		    For i As Integer= 0 To transfrmts.Ubound
		      Dim trans As String= transfrmts(i)
		      Dim values() As Double= ParseDrawValues(trans)
		      
		      If trans.InStr("rotate")> 0 Then
		        Dim angle, cx, cy As Double
		        For j As Integer= 0 To values.Ubound Step 3
		          angle= values(j)
		          If (j+ 1)<= values.Ubound Then cx= values(j+ 1)
		          If (j+ 2)<= values.Ubound Then cy= values(j+ 2)
		        Next
		        If angle<> 0 Then valuesR.Append angle
		        If cx<> 0 Then valuesR.Append cx
		        If cy<> 0 Then valuesR.Append cy
		      End If
		      
		    Next
		  End If
		  
		  Return valuesR
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTransformRotateRecursive(node As XmlElement) As Double()
		  Dim valuesR() As Double= GetTransformRotate(node)
		  
		  Dim valuesNodes() As Pair
		  valuesNodes.Append New Pair(node.Name, valuesR)
		  
		  Dim parentNode As XmlNode= node.Parent
		  
		  Do
		    If parentNode<> Nil And parentNode IsA XmlElement Then
		      Dim valuesParent() As Double= GetTransformRotate(XmlElement(parentNode))
		      valuesNodes.Append New Pair(parentNode.Name, valuesParent)
		      
		      parentNode= parentNode.Parent
		    End If
		    
		  Loop Until parentNode IsA XmlDocument
		  
		  For i As Integer= 0 To valuesNodes.Ubound
		    Dim p As Pair= valuesNodes(i)
		    Dim valuesTmp() As Double= p.Right
		    
		    If valuesTmp.Ubound= 2 Then
		      valuesR(0)= valuesTmp(0)
		      valuesR(1)= valuesTmp(1)
		      valuesR(2)= valuesTmp(2)
		    ElseIf valuesTmp.Ubound= 1 Then
		      valuesR(0)= valuesTmp(0)
		      valuesR(1)= valuesTmp(1)
		    ElseIf valuesTmp.Ubound= 0 Then
		      valuesR(0)= valuesTmp(0)
		    End If
		    
		  Next
		  
		  Return valuesR
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTransformScale(node As XmlElement) As Double
		  Dim scale As Double
		  
		  Dim transform As String= node.GetAttribute("transform")
		  If transform<> "" Then
		    Dim transfrmts() As String= ParseTransformations(transform)
		    
		    For i As Integer= 0 To transfrmts.Ubound
		      Dim trans As String= transfrmts(i)
		      Dim values() As Double= ParseDrawValues(trans)
		      
		      If trans.InStr("scale")> 0 Then
		        Dim scaleTmp As Double
		        For j As Integer= 0 To values.Ubound Step 3
		          scaleTmp= values(j)
		        Next
		        If scaleTmp<> 0 Then scale= scaleTmp
		      End If
		      
		    Next
		  End If
		  
		  Return scale
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function GetTransformScaleRecursive(node As XmlElement) As Double
		  Dim scale As Double= GetTransformScale(node)
		  
		  Dim parentNode As XmlNode= node.Parent
		  
		  Do
		    If parentNode<> Nil And parentNode IsA XmlElement Then
		      Dim scaleParent As Double= GetTransformScale(XmlElement(parentNode))
		      scale= scale+ scaleParent
		      
		      parentNode= parentNode.Parent
		    End If
		    
		  Loop Until parentNode IsA XmlDocument
		  
		  If scale= 0 Then scale= 1
		  
		  Return scale
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HasFillStyle(node As XmlElement) As Boolean
		  If (node.GetAttribute("fill")<> "" And node.GetAttribute("fill")<> "none") Or (node.GetSubAttribute("style", "fill")<> "" _
		    And node.GetSubAttribute("style", "fill")<> "none") Then
		    Return True
		  End If
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HasFillStyleRecursive(node As XmlElement) As Boolean
		  If HasFillStyle(node) Then Return True
		  
		  Dim parentNode As XmlNode= node.Parent
		  
		  Do
		    If parentNode<> Nil And parentNode IsA XmlElement Then
		      If HasFillStyle(XmlElement(parentNode)) Then Return True
		      
		      parentNode= parentNode.Parent
		    End If
		    
		  Loop Until parentNode IsA XmlDocument
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Init()
		  Dim rootXML As XmlElement= Self.CreateElement(kXmlTagSvg)
		  rootXML.SetAttribute(kXmlAttrXmlnsTag, kXmlAttrXmlnsValue)
		  rootXML.SetAttribute(kXmlAttrXmlnsXlinkTag, kXmlAttrXmlnsXlinkValue)
		  'rootXML.SetAttribute("width", "500")
		  'rootXML.SetAttribute("height", "300")
		  
		  'LBMSoft.Debug.Assert Not (rootXML Is Nil)
		  
		  Self.AppendChild(rootXML)
		  
		  mTransforms= New Dictionary
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitChk()
		  mTransforms= New Dictionary
		  
		  If FirstChild= Nil Then
		    Init
		    Return
		  End If
		  
		  'LBMSoft.Debug.Assert (ChildCount> 0)
		  
		  // search for <svg> tag
		  Dim svgTagOk As Boolean
		  For i As Integer= 0 To ChildCount- 1
		    Dim node As XmlNode= Child(i)
		    If node.Name= kXmlTagSvg Then
		      svgTagOk= True
		      Exit For i
		    End If
		  Next
		  
		  If svgTagOk Then
		    LoadCSS
		  Else
		    Dim rootXML As XmlElement= Self.CreateElement(kXmlTagSvg)
		    rootXML.SetAttribute(kXmlAttrXmlnsTag, kXmlAttrXmlnsValue)
		    rootXML.SetAttribute(kXmlAttrXmlnsXlinkTag, kXmlAttrXmlnsXlinkValue)
		    'rootXML.SetAttribute("width", "500")
		    'rootXML.SetAttribute("height", "300")
		    
		    Try
		      DeleteAllChildren
		      
		      AppendChild rootXML
		      
		      // TODO: copy from ori
		    Catch e As XmlException
		      DebugLog CurrentMethodName+ " Insert rootXML, FirstChild [error]: "+ e.Message
		    End Try
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub LoadCSS()
		  Dim nodes As XmlNodeList= Xql("//style")
		  
		  Dim styles As String
		  
		  For i As Integer= 0 To nodes.Length- 1
		    Dim node As XmlNode= nodes.Item(i)
		    If node.FirstChild<> Nil Then styles= styles+ EndOfLine+ node.FirstChild.Value
		  Next
		  
		  mKeysCSS= ParseCSS(styles)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function MatrixMultiply(m1() As Double, m2() As Double) As Double()
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim result(8) As Double
		  
		  result(0) = m1(0) * m2(0) + m1(1) * m2(3) + m1(2) * m2(6)
		  result(1) = m1(0) * m2(1) + m1(1) * m2(4) + m1(2) * m2(7)
		  result(2) = m1(0) * m2(2) + m1(1) * m2(5) + m1(2) * m2(8)
		  
		  result(3) = m1(3) * m2(0) + m1(4) * m2(3) + m1(5) * m2(6)
		  result(4) = m1(3) * m2(1) + m1(4) * m2(4) + m1(5) * m2(7)
		  result(5) = m1(3) * m2(2) + m1(4) * m2(5) + m1(5) * m2(8)
		  
		  result(6) = m1(6) * m2(0) + m1(7) * m2(3) + m1(8) * m2(6)
		  result(7) = m1(6) * m2(1) + m1(7) * m2(4) + m1(8) * m2(7)
		  result(8) = m1(6) * m2(2) + m1(7) * m2(5) + m1(8) * m2(8)
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseColor(str As String) As Color
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Static dColor As Dictionary
		  If dColor= Nil Then
		    dColor= New Dictionary("aliceblue" : &cf0f8ff, "antiquewhite" : &cfaebd7, "aqua" : &c00ffff, "azure" : &cf0ffff,  _
		    "beige": &cf5f5dc, "bisque" : &cffe4c4, "black" : &c000000, "blanchedalmond" : &cffebcd, "blue" : &c0000ff, _
		    "blueviolet" : &c8a2be2, "brown" : &ca52a2a, "burlywood" : &cdeb887, "cadetblue" : &c5f9ea0, _
		    "chartreuse" : &c7fff00, "chocolate" : &cd2691e, "coral" : &cff7f50, "cornflowerblue" : &c6495ed, _
		    "cornsilk" : &cfff8dc, "crimson" : &cdc143c, "cyan" : &c00ffff, "darkblue" : &c00008b, "darkcyan" : &c008b8b, _
		    "darkgoldenrod" : &cb8860b, "darkgray" : &ca9a9a9, "darkgreen" : &c006400, "darkgrey" : &ca9a9a9, _
		    "darkkhaki" : &cbdb76b, "darkmagenta" : &c8b008b, "darkolivegreen" : &c556b2f, "darkorange" : &cff8c00, _
		    "darkorchid" : &c9932cc, "darkred" : &c8b0000, "darksalmon" : &c39967a, "darkseagreen" : &c8fbc8f, _
		    "darkslateblue" : &c483d8b, "darkslategray" : &c2f4f4f, "darkslategrey" : &c2f4f4f, "darkturquoise" : &c00ced1, _
		    "darkviolet" : &c9400d3, "deeppink" : &cff1493, "deepskyblue" : &c00bfff, "dimgray" : &c696969, _
		    "dimgrey" : &c696969, "dodgerblue" : &c1e90ff, "firebrick" : &cb22222, "floralwhite" : &cfffaf0, _
		    "forestgreen" : &c228b22, "fuchsia" : &cff00ff, "gainsboro" : &cdcdcdc, "ghostwhite" : &cf8f8ff, _
		    "gold" : &cffd700, "goldenrod" : &cdaa520, "gray" : &c8080, "grey" : &c8080, "green" : &c008000, _
		    "greenyellow" : &cadff2f, "honeydew" : &cf0fff0, "hotpink" : &cff69b4, "indianred" : &ccd5c5c, _
		    "indigo" : &c4b0082, "ivory" : &cfffff0, "khaki" : &cf0e68c, "lavender" : &ce6e6fa, "lavenderblush" : &cfff0f5, _
		    "lawngreen" : &c7cfc00, "lemonchiffon" : &cfffacd, "lightblue" : &cadd8e6, "lightcoral" : &cf08080, _
		    "lightcyan" : &ce0ffff, "lightgoldenrodyellow" : &cfafad2, "lightgray" : &cd3d3d3, "lightgreen" : &c90ee90, _
		    "lightgrey" : &cd3d3d3, "lightpink" : &cffb6c1, "lightsalmon" : &cffa07a, "lightseagreen" : &c20b2aa, _
		    "lightskyblue" : &c87cefa, "lightslategray" : &c778899, "lightslategrey" : &c778899, "lightsteelblue" : &cb0c4de, _
		    "lightyellow" : &cffffe0, "lime" : &c00ff00, "limegreen" : &c32cd32, "linen" : &cfaf0e6, "magenta" : &cff00ff, _
		    "maroon" : &c800000, "mediumaquamarine" : &c66cdaa, "mediumblue" : &c0000cd, _
		    "mediumorchid" : &cba55d3, "mediumpurple" : &c9370db, "mediumseagreen" : &c3cb371, _
		    "mediumslateblue" : &c7b68ee, "mediumspringgreen" : &c00fa9a, "mediumturquoise" : &c48d1cc, _
		    "mediumvioletred" : &cc71585, "midnightblue" : &c191970, "mintcream" : &cf5fffa, "mistyrose" : &cffe4e1, _
		    "moccasin" : &cffe4b5, "navajowhite" : &cffdead, "navy" : &c000080, "oldlace" : &cfdf5e6, "olive" : &c808000, _
		    "olivedrab" : &c6b8e23, "orange" : &cffa500, "orangered" : &cff4500, "orchid" : &cda70d6, _
		    "palegoldenrod" : &ceee8aa, "palegreen" : &c98fb98, "paleturquoise" : &cafeeee, "palevioletred" : &cdb7093, _
		    "papayawhip" : &cffefd5, "peachpuff" : &cffdab9, "peru" : &ccd853f, "pink" : &cffc0cb, "plum" : &cdda0dd, _
		    "powderblue" : &cb0e0e6, "purple" : &c800080, "red" : &cff0000, "rosybrown" : &cbc8f8f, "royalblue" : &c4169e1, _
		    "saddlebrown" : &c8b4513, "salmon" : &cfa8072, "sandybrown" : &cf4a460, "seagreen" : &c2e8b57, _
		    "seashell" : &cfff5ee, "sienna" : &ca0522d, "silver" : &cc0c0c0, "skyblue" : &c87ceeb, "slateblue" : &c6a5acd, _
		    "slategray" : &c708090, "slategrey" : &c708090, "snow" : &cfffafa, "springgreen" : &c00ff7f, _
		    "steelblue" : &c4682b4, "tan" : &cd2b4bc, "teal" : &c008080, "thistle" : &cd8bfd8, "tomato" : &cff6347, _
		    "turquoise" : &c40e0d0, "violet" : &cee82ee, "wheat" : &cf5deb3, "white" : &cffffff, "whitesmoke" : &cf5f5f5, _
		    "yellow" : &cffff00, "yellowgreen" : &c9acd32)
		  End If
		  
		  Dim colr As Color
		  Dim colStr As String= str.Lowercase.Trim
		  
		  If dColor.HasKey(colStr) then
		    colr= dColor.Value(colStr)
		  ElseIf str.Left(3)= "rgb" Then
		    Dim iniPos As Integer= colStr.InStr("(")
		    Dim endPos As Integer= colStr.InStr(iniPos+ 1, ")")
		    If (iniPos> 0) And (endPos> 0) Then
		      Dim tmpStr As String= colStr.Mid(iniPos+ 1, endPos- iniPos- 1)
		      Dim tmpArr() As String= tmpStr.Split(",")
		      If tmpArr.Ubound= 2 Then colr= RGB(Val(tmpArr(0)), Val(tmpArr(1)), Val(tmpArr(2)))
		    End if
		  ElseIf colStr= "none" Then
		    colr= &c00000000
		  Else
		    colr= ColorFromHex(colStr)
		  End If
		  
		  Return colr
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseCSS(cssText As String) As Dictionary
		  // sanity chk
		  If cssText= "" Then Return New Dictionary
		  
		  cssText= ReplaceLineEndings(cssText, EndOfLine.Windows)
		  
		  // (?<selector>(?:(?:[^,{]+),?)*?)\{(?:(?<name>[^}:]+):?(?<value>[^};]+);?)*?\}
		  Const cssTextGroups= "((?:(?:[^,{]+),?)*?)\{(?:([^}:]+):?([^};]+);?)*?\}"
		  Const cssTextComments= "\/\*[\s\S]*?\*\/|\/\/.*"
		  Const cssAtSingGroups= "(@[^\{]+)\{([\s\S]+?\})\s*\}"
		  Const cssImport= "(@import)(\s+['""](.+?))?(\s+url\((.+?))?;"
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  Dim dKeys As Dictionary= New Dictionary
		  
		  // replace @import
		  rg.SearchPattern= cssImport
		  rg.ReplacementPattern= ""
		  rg.Options.ReplaceAllMatches= True
		  cssText= rg.Replace(cssText)
		  
		  // replace comments
		  rg.SearchPattern= cssTextComments
		  rg.ReplacementPattern= ""
		  rg.Options.ReplaceAllMatches= True
		  cssText= rg.Replace(cssText)
		  
		  // replace @groups
		  rg.SearchPattern= cssAtSingGroups
		  rg.ReplacementPattern= ""
		  rg.Options.ReplaceAllMatches= True
		  cssText= rg.Replace(cssText)
		  
		  // search
		  rg.SearchPattern= cssTextGroups
		  rgm= rg.search(cssText)
		  
		  While rgm<> Nil
		    Dim s As String= rgm.SubExpressionString(0).ReplaceAll(EndOfLine.Windows, " ")
		    Dim part2 As String= s.Mid(s.InStr("{")).Trim
		    Dim part2a As String= part2.ReplaceAll("{", " ").ReplaceAll("}", " ").Trim
		    Dim dValues As New Dictionary
		    For i As Integer= 1 To CountFields(part2a, ";")
		      Dim part2b As String= NthField(part2a, ";", i).Trim
		      If part2b<> "" Then
		        Dim key As String= part2b.Left(part2b.InStr(":")- 1).Trim
		        Dim valu As String= part2b.Mid(part2b.InStr(":")+ 1).Trim
		        dValues.Value(key)= valu
		      End If
		    Next
		    
		    Dim part1 As String= s.Left(s.InStr("{")- 1).Trim
		    Dim keys() As String= part1.Split(",")
		    
		    For i As Integer= 0 To keys.Ubound
		      Dim key As String= keys(i).Trim
		      dKeys.Value(key)= dValues
		    Next
		    
		    rgm= rg.Search
		  Wend
		  
		  Return dKeys
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return dKeys
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseDraw(str As String) As String()
		  Dim draws() As String
		  
		  If str= "" Then Return draws
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  // \S([-]?(\d)*[.]?(\d)*[,]*[\s]*[-]?(\d)*[.]?(\d)*)+
		  rg.SearchPattern= "[MmLlHhVvCcSsQqTtAaZz]([-]?(\d)*[.]?(\d)*[,]*[\s]*[-]?(\d)*[.]?(\d)*[e]*)+"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    draws.Append rgm.SubExpressionString(0).Trim
		    
		    rgm= rg.Search
		  Wend
		  
		  Return draws
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return draws
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseDrawPoints(str As String) As PointS()
		  #pragma BackgroundTasks False
		  
		  Dim points() As PointS
		  
		  // sanity chk
		  If str= "" Then Return points
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  Dim values() As Double
		  
		  // search
		  rg.SearchPattern= "([-]?\d*[.]?\d*[e]+[-]?\d*)*([-]?\d*[.]?(\d)+)" // ([-]?\d*[.]?(\d)+)
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    values.Append rgm.SubExpressionString(0).ParseUnits
		    
		    rgm= rg.Search
		  Wend
		  
		  For i As Integer= 0 To values.Ubound Step 2
		    Dim pnt1 As New PointS(values(i), 0)
		    If (i+ 1)<= values.Ubound Then pnt1.Y= values(i+ 1)
		    points.Append pnt1
		  Next
		  
		  Return points
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return points
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseDrawValues(str As String) As Double()
		  #pragma BackgroundTasks False
		  
		  Dim values() As Double
		  
		  // sanity chk
		  If str= "" Then Return values
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  rg.SearchPattern= "([-]?\d*[.]?\d*[e]+[-]?\d*)*([-]?\d*[.]?(\d)+)"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    values.Append rgm.SubExpressionString(0).ParseUnits
		    
		    rgm= rg.Search
		  Wend
		  
		  Return values
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return values
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseImage(uri As String) As Picture
		  // sanity chk
		  If uri= "" Then Return New Picture(1,  1, 32)
		  
		  Dim p As Picture
		  
		  If uri.InStr("data:image/png;base64,")> 0 Then
		    Dim pData As String= NthField(uri, ",", 2).Trim
		    p= Picture.FromData(DecodeBase64(pData))
		  Else // try load synchronously
		    Dim pData As String
		    If uri.InStr("https")> 0 Then
		      Dim http As New HTTPSecureSocket
		      http.Secure= True
		      #if RBVersion> 2015
		        http.ConnectionType= SSLSocket.TLSv12
		      #else
		        http.ConnectionType= SSLSocket.TLSv1
		      #endif
		      pData= http.Get(uri, 3)
		    Else
		      Dim http As New HTTPSocket
		      pData= http.Get(uri, 3)
		    End If
		    If pData.Len> 0 Then p= Picture.FromData(pData)
		  End If
		  
		  If p= Nil Then p=New Picture(1,  1, 32)
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParsePoint(str As String) As PointS
		  If str= "" Then Return New PointS
		  
		  Dim values() As Double
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  rg.SearchPattern= "([-]?\d*[.]?\d*[e]+[-]?\d*)*([-]?\d*[.]?(\d)+)"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    values.Append rgm.SubExpressionString(0).ParseUnits
		    
		    rgm= rg.Search
		  Wend
		  
		  Dim pnt As New PointS
		  
		  For i As Integer= 0 To values.Ubound
		    If i= 0 Then pnt.X= values(i)
		    If i= 1 Then pnt.Y= values(i)
		  Next
		  
		  Return pnt
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParsePoints(str As String) As PointS()
		  Dim points() As PointS
		  
		  If str= "" Then Return points
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  // (([-]?\d*[.]?(\d)+)),[\s]*(([-]?\d*[.]?(\d)+))
		  rg.SearchPattern= "([-]?\d*[.]?\d*[e]+[-]?\d*)*([-]?\d*[.]?(\d)+),[\s]*([-]?\d*[.]?\d*[e]+[-]?\d*)*([-]?\d*[.]?(\d)+)"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    Dim s As String= rgm.SubExpressionString(0).ReplaceAll(" ", "")
		    points.Append New PointS(s.Left(s.InStr(",")- 1).ParseUnits, s.Mid(s.InStr(",")+ 1).ParseUnits)
		    
		    rgm= rg.Search
		  Wend
		  
		  Return points
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return points
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseTransformations(str As String) As String()
		  Dim draws() As String
		  
		  If str= "" Then Return draws
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  rg.SearchPattern= "\S*\(([0-9]*[,.]*[-]*[ ]*[0-9]?)+\)"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    draws.Append rgm.SubExpressionString(0).Trim
		    
		    rgm= rg.Search
		  Wend
		  
		  Return draws
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return draws
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseURL(str As String) As String
		  Dim ret As String= str.Trim.Mid(str.InStr("#")) // regex: [#][a-zA-Z0-9]
		  ret= ret.Mid(2, ret.InStr(")")- 2).Trim
		  
		  Return ret
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ParseViewBox(str As String) As Integer()
		  Dim values() As Integer
		  
		  If str= "" Then Return values
		  
		  Dim rg As New RegEx
		  Dim rgm As RegExMatch
		  
		  // search
		  rg.SearchPattern= "[-]*\d+"
		  rgm= rg.Search(str)
		  
		  While rgm<> Nil
		    values.Append rgm.SubExpressionString(0).Val
		    
		    rgm= rg.Search
		  Wend
		  
		  Return values
		  
		Exception err as RegExException
		  DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return values
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function ReflectionValue(base As Double, previous As Double) As Double
		  Dim ret As Double= base
		  
		  If previous<> 0 Then ret= base+ (base- previous)
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetStyle(shape As Object2D, node As XmlElement)
		  Dim style As String
		  
		  If node.GetAttribute("class")<> "" Then
		    style= GetStyle("."+ node.GetAttribute("class"), "stroke")
		    If style<> "" And style<> "none" Then
		      shape.Border= 100
		      shape.BorderColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Border= 0
		    End If
		    
		    style= GetStyle("."+ node.GetAttribute("class"), "stroke-opacity")
		    If style<> "" And style<> "none" Then shape.Border= style.ParseUnits* 100
		    
		    style= GetStyle("."+ node.GetAttribute("class"), "stroke-width")
		    If style<> "" Then
		      shape.BorderWidth= style.ParseUnits
		      If shape.BorderWidth< 1 Then
		        shape.BorderColor= RGB(shape.BorderColor.Red, shape.BorderColor.Green, shape.BorderColor.Blue, 180)
		      End If
		    Else
		      shape.BorderWidth= 1.5
		    End If
		    
		    style= GetStyle("."+ node.GetAttribute("class"), "fill")
		    If style<> "" And style<> "none" Then
		      shape.Fill= 100
		      shape.FillColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Fill= 0
		    End If
		    
		    style= GetStyle("."+ node.GetAttribute("class"), "fill-opacity")
		    If style<> "" And style<> "none" Then shape.Fill= style.ParseUnits* 100
		    
		  ElseIf node.GetAttribute("style")<> "" Then
		    style= node.GetSubAttribute("style", "stroke")
		    If style<> "" And style<> "none" Then
		      shape.Border= 100
		      shape.BorderColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Border= 0
		    End If
		    
		    style= node.GetSubAttribute("style", "stroke-opacity")
		    If style<> "" And style<> "none" Then shape.Border= style.ParseUnits* 100
		    
		    style= node.GetSubAttribute("style", "stroke-width")
		    If style<> "" Then
		      shape.BorderWidth= style.ParseUnits
		      If shape.BorderWidth< 1 Then
		        shape.BorderColor= RGB(shape.BorderColor.Red, shape.BorderColor.Green, shape.BorderColor.Blue, 180)
		      End If
		    Else
		      shape.BorderWidth= 1.5
		    End If
		    
		    style= node.GetSubAttribute("style", "fill")
		    If style<> "" And style<> "none" Then
		      shape.Fill= 100
		      shape.FillColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Fill= 0
		    End If
		    
		    style= node.GetSubAttribute("style", "fill-opacity")
		    If style<> "" And style<> "none" Then shape.Fill= style.ParseUnits* 100
		    
		  Else
		    style= node.GetAttribute("stroke")
		    If style<> "" And style<> "none" Then
		      shape.Border= 100
		      shape.BorderColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Border= 0
		    End If
		    
		    style= node.GetAttribute("stroke-opacity")
		    If style<> "" And style<> "none" Then shape.Border= style.ParseUnits* 100
		    
		    style= node.GetAttribute("stroke-width")
		    If style<> "" Then
		      shape.BorderWidth= style.ParseUnits
		      If shape.BorderWidth< 1 Then
		        shape.BorderColor= RGB(shape.BorderColor.Red, shape.BorderColor.Green, shape.BorderColor.Blue, 180)
		      End If
		    Else
		      shape.BorderWidth= 1.5
		    End If
		    
		    style= node.GetAttribute("fill")
		    If style<> "" And style<> "none" Then
		      shape.Fill= 100
		      shape.FillColor= ParseColor(style)
		    ElseIf style= "none" Then
		      shape.Fill= 0
		    End If
		    
		    style= node.GetAttribute("fill-opacity")
		    If style<> "" And style<> "none" Then shape.Fill= style.ParseUnits* 100
		    
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetStyleMask(shape As Group2D, node As XmlElement)
		  Dim cssMask As String= node.GetSubAttribute("style", "mask")
		  
		  If cssMask= "" Then Return
		  
		  Dim maskid As String= ParseURL(cssMask)
		  
		  Dim mask As XmlElement= GetDefinitionByID(maskid)
		  
		  If mask= Nil Then Return
		  
		  If mask.GetAttribute("width").ParseUnits< 1 And mask.GetAttribute("height").ParseUnits< 1 Then Return
		  
		  Dim pMask As New Picture(mask.GetAttribute("width").ParseUnits, mask.GetAttribute("height").ParseUnits, 32)
		  Dim gMask As Graphics= pMask.Graphics
		  
		  For i As Integer= 0 To mask.ChildCount- 1
		    If Not (mask.Child(i) IsA XmlElement) Then Continue
		    Dim maskChild As XmlElement= XmlElement(mask.Child(i))
		    
		    Select Case maskChild.Name
		    Case kXmlTagCircle
		    Case kXmlTagEllipse
		    Case kXmlTagRect
		      Dim style As String= maskChild.GetSubAttribute("style", "fill")
		      If style.InStr("url")> 0 Then
		        Dim grp As New Group2D
		        If SetStyleUrl(style, grp, maskChild) Then
		          If grp.Count> 0 Then
		            gMask.DrawObject(grp, 0, 0)
		          End If
		        End If
		      Else
		        gMask.ForeColor= ParseColor(style)
		        gMask.FillRect maskChild.GetAttribute("x").ParseUnits, maskChild.GetAttribute("y").ParseUnits, _
		        maskChild.GetAttribute("width").ParseUnits, maskChild.GetAttribute("height").ParseUnits
		      End If
		    End Select
		  Next
		  
		  // TODO: dont show transparent
		  Dim p As New Picture(mask.GetAttribute("width").ParseUnits, mask.GetAttribute("height").ParseUnits, 32)
		  p.Mask= pMask
		  
		  'Dim shape1 As Object2D= shape.Item(shape.Count- 1)
		  'p.Graphics.DrawObject shape1, 0, 0
		  'p.Graphics.ForeColor= &c00808000
		  'p.Graphics.FillRect 10, 10, mask.GetAttribute("width").ParseUnits- 20, mask.GetAttribute("height").ParseUnits -20
		  
		  Dim px As New PixmapShape(p)
		  px.X= node.GetAttribute("x").ParseUnits+ node.GetAttribute("width").ParseUnits/ 2
		  px.Y= node.GetAttribute("y").ParseUnits+ node.GetAttribute("height").ParseUnits/ 2
		  
		  shape.Append px
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetStylePattern(pic As Picture, patt As XmlElement, picWidth As Integer, picHeight As Integer)
		  #If Not DebugBuild
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  Dim grp As New Group2D
		  
		  For i As Integer= 0 To patt.ChildCount- 1
		    If Not (patt.Child(i) IsA XmlElement) Then Continue
		    Dim node As XmlElement= XmlElement(patt.Child(i))
		    
		    Select Case node.Name
		    Case kXmlTagCircle
		      AddCircle grp, node
		    Case kXmlTagEllipse
		      AddEllipse grp, node
		    Case kXmlTagImage
		      AddImage grp, node
		    Case kXmlTagLine
		      AddLine grp, node
		    Case kXmlTagRect
		      AddRect grp, node
		    End Select
		  Next
		  
		  If grp.Count= 0 Then Return
		  
		  Dim rect1 As New RectS(patt.GetAttribute("x").ParseUnits, patt.GetAttribute("y").ParseUnits, _
		  patt.GetAttribute("width").ParseUnits, patt.GetAttribute("height").ParseUnits)
		  
		  For x As Integer= rect1.X To picWidth+ rect1.Width Step rect1.Width
		    For y As Integer= rect1.Y To picHeight+ rect1.Height Step rect1.Height
		      pic.Graphics.DrawObject grp, x- rect1.Width, y- rect1.Height
		    Next
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetStyleRecursive(shape As Object2D, node As XmlElement)
		  Dim parentNode As XmlNode= node.Parent
		  
		  Do
		    If parentNode<> Nil And parentNode IsA XmlElement Then
		      If parentNode.GetAttribute("style")<> "" Or parentNode.GetAttribute("stroke")<> "" Or _
		        parentNode.GetAttribute("stroke-width")<> "" Or parentNode.GetAttribute("fill")<> "" Or _
		        parentNode.GetAttribute("stroke-opacity")<> "" Or parentNode.GetAttribute("fill-opacity")<> "" Or _
		        parentNode.GetAttribute("class")<> "" Then
		        SetStyle shape, XmlElement(parentNode)
		        Exit
		      End If
		      parentNode= parentNode.Parent
		    End If
		    
		  Loop Until parentNode IsA XmlDocument
		  
		  SetStyle shape, node
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetStyleText(shape As StringShape, node As XmlElement)
		  Dim fontSize As Double= node.GetSubAttribute("style", "font-size").ParseUnits
		  If fontSize= 0 Then
		    If GetStyle("."+ node.GetAttribute("class"), "font-size")<> "" Then
		      shape.TextSize= GetStyle("."+ node.GetAttribute("class"), "font-size").ParseUnits
		    ElseIf node.GetAttribute("font-size").ParseUnits<> 0 Then
		      shape.TextSize= node.GetAttribute("font-size").ParseUnits
		    Else
		      shape.TextSize= 16
		    End If
		  Else
		    shape.TextSize= fontSize
		  End If
		  
		  Dim fontFamily As String= node.GetSubAttribute("style", "font-family")
		  If fontFamily= "" Then
		    If GetStyle("."+ node.GetAttribute("class"), "font-family")<> "" Then
		      shape.TextFont= GetStyle("."+ node.GetAttribute("class"), "font-family")
		    ElseIf node.GetAttribute("font-family")<> "" Then
		      shape.TextFont= node.GetAttribute("font-family")
		    End If
		  Else
		    shape.TextFont= fontFamily
		  End If
		  
		  Dim textAnchor As String= node.GetSubAttribute("style", "text-anchor")
		  If textAnchor= "" Then
		    If GetStyle("."+ node.GetAttribute("class"), "text-anchor")<> "" Then
		      textAnchor= GetStyle("."+ node.GetAttribute("class"), "text-anchor")
		    ElseIf node.GetAttribute("font-anchor")<> "" Then
		      textAnchor= node.GetAttribute("font-anchor")
		    End If
		  End If
		  Select Case textAnchor.Trim.Lowercase
		  Case "middle"
		    shape.HorizontalAlignment= StringShape.Alignment.Center
		  Case "end"
		    shape.HorizontalAlignment= StringShape.Alignment.Right
		  End Select
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SetStyleUrl(shape As Group2D, node As XmlElement) As Boolean
		  Dim style As String
		  
		  If node.GetAttribute("class")<> "" Then
		    style= GetStyle("."+ node.GetAttribute("class"), "fill")
		    If style.Lowercase.InStr("url")> 0 Then Return SetStyleUrl(style, shape, node)
		  ElseIf node.GetAttribute("style")<> "" Then
		    style= node.GetSubAttribute("style", "fill")
		    If style.Lowercase.InStr("url")> 0 Then Return SetStyleUrl(style, shape, node)
		  Else
		    style= node.GetAttribute("fill")
		    If style.Lowercase.InStr("url")> 0 Then Return SetStyleUrl(style, shape, node)
		  End If
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function SetStyleUrl(cssProp As String, shape As Group2D, node As XmlElement) As Boolean
		  Dim pattid As String= ParseURL(cssProp)
		  
		  Dim patt As XmlElement= GetDefinitionByID(pattid)
		  
		  If patt= Nil Then Return False
		  
		  If patt.Name.InStr("Gradient")> 0 Then
		    Dim pColors() As Pair
		    
		    For i As Integer= 0 To patt.ChildCount- 1
		      If Not (patt.Child(i) IsA XmlElement) Then Continue
		      Dim nodeStop As XmlElement= XmlElement(patt.Child(i))
		      Dim offset As Double= nodeStop.GetAttribute("offset").ParseUnits/ 100
		      Dim colr As Color= ParseColor(nodeStop.GetAttribute("stop-color"))
		      Dim opac As Double= nodeStop.GetAttribute("stop-opacity").ParseUnits
		      colr= RGB(colr.Red, colr.Green, colr.Blue, colr.Alpha* opac)
		      
		      pColors.Append New Pair(offset, colr)
		    Next
		    
		    Dim px As PixmapShape
		    
		    If patt.Name.InStr("linear")> 0 Then
		      Dim rotation As Double
		      If patt.GetAttribute("x2").ParseUnits> 0 Then rotation= -90
		      px= Shape2D.GradientLinearR(node.GetAttribute("width").ParseUnits, node.GetAttribute("height").ParseUnits, _
		      pColors, rotation)
		    ElseIf patt.Name.InStr("radial")> 0 Then
		      px= Shape2D.GradientRadial(node.GetAttribute("width").ParseUnits, node.GetAttribute("height").ParseUnits, _
		      pColors)
		    End If
		    px.X= node.GetAttribute("x").ParseUnits+ node.GetAttribute("width").ParseUnits/ 2
		    px.Y= node.GetAttribute("y").ParseUnits+ node.GetAttribute("height").ParseUnits/ 2
		    
		    shape.Append px
		  ElseIf patt.Name.InStr("pattern")> 0 Then
		    Dim picWidth, picHeight As Integer
		    
		    Select Case node.Name
		    Case kXmlTagCircle
		      picWidth= node.GetAttribute("r").ParseUnits* 2
		      picHeight= picWidth
		    Case kXmlTagEllipse
		      picWidth= node.GetAttribute("rx").ParseUnits* 2
		      picHeight= node.GetAttribute("rx").ParseUnits* 2
		    Case kXmlTagImage
		      picWidth= node.GetAttribute("width").ParseUnits
		      picHeight= node.GetAttribute("height").ParseUnits
		    Case kXmlTagRect
		      picWidth= node.GetAttribute("width").ParseUnits
		      picHeight= node.GetAttribute("height").ParseUnits
		    End Select
		    
		    If picWidth> 0 And picWidth> 0 Then
		      Dim pic As New Picture(picWidth, picHeight)
		      SetStylePattern pic, patt, picWidth, picHeight
		      
		      Dim px As New PixmapShape(pic)
		      px.X= node.GetAttribute("x").ParseUnits+ picWidth/ 2
		      px.Y= node.GetAttribute("y").ParseUnits+ picHeight/ 2
		      
		      shape.Append px
		    End If
		  End If
		  
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetTransforms(node As XmlElement)
		  If node.GetAttribute("transform")= "" Then Return
		  
		  Dim matrix() As Double= GetMatrixRecursive(node)
		  
		  If matrix.Ubound<> -1 Then
		    Dim key As String= node.GetAttribute("xlink:href")
		    key= key.Mid(key.InStr("#")+ 1)
		    mTransforms.Value(key)= matrix
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToGroup2D(useCache As Boolean = True) As Group2D
		  Dim svg As XmlElement= Root
		  
		  If svg= Nil Then
		    Dim grp As New Group2D
		    Dim str As New StringShape
		    str.Text= "Sorry, svg node is missing!"
		    str.HorizontalAlignment= StringShape.Alignment.Left
		    str.X= 10
		    str.Y= 20
		    
		    grp.Append str
		    Return grp
		  End If
		  
		  If useCache Then
		    If mShapeCache<> Nil Then Return mShapeCache
		  End If
		  
		  Dim shape As New Group2D
		  
		  For i As Integer= 0 To svg.ChildCount- 1
		    Dim node As XmlNode= svg.Child(i)
		    If node IsA XmlElement Or node IsA XmlTextNode Then
		      AddObject2D shape, XmlElement(node)
		    End If
		  Next
		  
		  // viewBox
		  Dim viewBox As New RectS
		  Dim values() As Integer= ParseViewBox(Root.GetAttribute("viewBox"))
		  
		  For i As Integer= 0 To values.Ubound
		    If i= 0 Then viewBox.X= values(i)
		    If i= 1 Then viewBox.Y= values(i)
		    If i= 2 Then viewBox.Width= values(i)
		    If i= 3 Then viewBox.Height= values(i)
		  Next
		  
		  Dim viewPort As New SizeS
		  viewPort.Width= Root.GetAttribute("width").ParseUnits
		  viewPort.Height= Root.GetAttribute("height").ParseUnits
		  
		  Dim scale As Double= 1
		  
		  If (viewPort.Width> 0 And viewPort.Height> 0) And (viewBox.Width> 0 And viewBox.Height> 0) Then
		    scale= (viewPort.Width+ viewPort.Height)/ (viewBox.Width+ viewBox.Height)
		    shape.Scale= scale
		  End If
		  
		  // viewBox x,y
		  shape.X= -1* viewBox.X* scale
		  shape.Y= -1* viewBox.Y* scale
		  
		  mShapeCache= shape
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPicture() As Picture
		  // sanity chk
		  If Root= Nil Then Return New Picture(1, 1, 32)
		  
		  Dim size As SizeS= ToGroup2D.GetSize
		  
		  Dim width As Integer= Root.GetAttribute("width").ParseUnits
		  If width= 0 Then width= size.Width
		  If width= 0 Then width= 500
		  
		  Dim height As Integer= Root.GetAttribute("height").ParseUnits
		  If height= 0 Then height= size.Height
		  If height= 0 Then height= 400
		  
		  Return ToPicture(width, height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPicture(width As Integer, height As Integer) As Picture
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As Picture
		  #if TargetConsole
		    #if RBVersion< 2012
		      p= New Picture(width, height, 32)
		    #else
		      p= New Picture(width, height)
		    #endif
		  #else
		    p= New Picture(width, height)
		  #endif
		  p.Graphics.DrawObject ToGroup2D(False), 0, 0
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToPictureVector(width As Integer, height As Integer) As Picture
		  Dim ret As New Picture(width, height, 0) // depth= 0  has no bitmap at all
		  ret.Objects= ToGroup2D(False)
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub TransformPoint(ByRef x As Double, ByRef y As Double, matrix() As Double)
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim cx As Double
		  Dim cy As Double
		  Dim cw As Double
		  
		  cx = matrix(0) * x + matrix(1) * y + matrix(2)
		  cy = matrix(3) * x + matrix(4) * y + matrix(5)
		  cw = matrix(6) * x + matrix(7) * y + matrix(8)
		  
		  x = (cx / cw)
		  y = (cy / cw)
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function TransformPoint(x As Double, y As Double, matrix() As Double) As PointS
		  TransformPoint x, y, matrix
		  
		  Return New PointS(x, y)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function TransformPoint(pnt1 As PointS, matrix() As Double) As PointS
		  If matrix.Ubound= -1 Then
		    Return pnt1.Clone
		  Else
		    Return TransformPoint(pnt1.X, pnt1.Y, matrix)
		  End If
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Object2DAdded(obj As Object2D, node As XmlElement)
	#tag EndHook


	#tag Note, Name = Readme
		
		# SVGDocument
		
		---
		
		Use SVG documents in Xojo. SVG is an XML document with special tags.
		You can load SVG files and render to Picture or Group2D objects. Also can create and manipulate SVG docs.
		
		
		## Example:
		```vb
		'Load:
		Dim svg As New SVGDocument(SpecialFolder.Documents.Child("Example.svg"))
		
		'Render to picture:
		Dim myPicture As Picture= svg.ToPicture
		
		'Render to Group2D:
		Dim myGroup As Group2D= svg.ToGroup2D
		
		'You can use FolderItem extended methods:
		Dim myFile As FolderItem= SpecialFolder.Documents.Child("Example.svg")
		Dim svg As SVGDocument= myFile.OpenAsSVG
		
		'or
		Dim myPicture As Picture= myFile.OpenAsSVG
		
		'or
		Dim myGroup As Group2D= myFile.OpenAsSVG
		```
		
		
		Copyright 2017-2020 Bernardo Monsalve (lbmonsalve@outlook.com)
		
		[repo](https://github.com/lbmonsalve/Xojo-SVGDocument.git)
	#tag EndNote


	#tag Property, Flags = &h21
		Private mKeysCSS As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mShapeCache As Group2D
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mTransforms As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  For i As Integer= 0 To ChildCount- 1
			    Dim node As XmlNode= Child(i)
			    If node IsA XmlElement And node.Name= kXmlTagSvg Then
			      Return XmlElement(node)
			    End If
			  Next
			  
			  Return Nil
			End Get
		#tag EndGetter
		Root As XmlElement
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return kVersion
			End Get
		#tag EndGetter
		Shared Version As String
	#tag EndComputedProperty


	#tag Constant, Name = kVersion, Type = String, Dynamic = False, Default = \"0.0.200422", Scope = Private, Attributes = \"Hidden"
	#tag EndConstant

	#tag Constant, Name = kXmlAttrXmlnsTag, Type = String, Dynamic = False, Default = \"xmlns", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlAttrXmlnsValue, Type = String, Dynamic = False, Default = \"http://www.w3.org/2000/svg", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlAttrXmlnsXlinkTag, Type = String, Dynamic = False, Default = \"xmlns:xlink", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlAttrXmlnsXlinkValue, Type = String, Dynamic = False, Default = \"http://www.w3.org/1999/xlink", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagCircle, Type = String, Dynamic = False, Default = \"circle", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagDefs, Type = String, Dynamic = False, Default = \"defs", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagDesc, Type = String, Dynamic = False, Default = \"desc", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagEllipse, Type = String, Dynamic = False, Default = \"ellipse", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagGroup, Type = String, Dynamic = False, Default = \"g", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagImage, Type = String, Dynamic = False, Default = \"image", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagLine, Type = String, Dynamic = False, Default = \"line", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagPath, Type = String, Dynamic = False, Default = \"path", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagPolygon, Type = String, Dynamic = False, Default = \"polygon", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagPolyline, Type = String, Dynamic = False, Default = \"polyline", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagRect, Type = String, Dynamic = False, Default = \"rect", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagScript, Type = String, Dynamic = False, Default = \"script", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagStyle, Type = String, Dynamic = False, Default = \"style", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagSvg, Type = String, Dynamic = False, Default = \"svg", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagText, Type = String, Dynamic = False, Default = \"text", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagTitle, Type = String, Dynamic = False, Default = \"title", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kXmlTagUse, Type = String, Dynamic = False, Default = \"use", Scope = Public
	#tag EndConstant


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
