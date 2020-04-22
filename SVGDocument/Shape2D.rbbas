#tag Class
Protected Class Shape2D
	#tag Method, Flags = &h0
		 Shared Function AngleBetweenVectors(u As Point, v As Point) As Double
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Const RadToDeg= 57.2958
		  
		  Dim angle As Double
		  
		  angle = ACos( (u.X * v.X + u.Y * v.Y) / ( Sqrt(u.X^2 + u.Y^2) * Sqrt(v.X^2 + v.Y^2) ) )
		  
		  if (u.x * v.y - u.y * v.x) < 0 then
		    angle = -Abs(angle)
		  else
		    angle = Abs(angle)
		  end if
		  
		  angle = angle * RadToDeg
		  
		  return angle
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ChessBoard(width As Single, height As Single, squareSize As Single = 10, color1 As Color = &cF2F2F200, color2 As Color = &cDBDBDB00) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As New Picture(width, height)
		  Dim g As Graphics= p.Graphics
		  
		  Dim firstColor As Color
		  
		  For x As Integer= 0 To width+ squareSize Step squareSize
		    For y As Integer= 0 To height+ squareSize Step squareSize
		      If g.ForeColor= color2 Then g.ForeColor= color1 Else g.ForeColor= color2
		      g.FillRect x, y, squareSize, squareSize
		      If y= 0 Then firstColor= g.ForeColor
		    Next
		    If g.ForeColor<> firstColor Then
		      If g.ForeColor= color2 Then g.ForeColor= color1 Else g.ForeColor= color2
		    End If
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ColorWheel(diameter As Integer, offset As Integer, bkColor As Color = &cF8F8F800) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (diameter> 0)
		  
		  #If Not DebugBuild
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If diameter< 1 Then diameter= 1
		  If diameter> 32767 Then diameter= 32767
		  
		  Dim pWidth As Integer= diameter
		  
		  Dim p As New Picture(pWidth, pWidth)
		  p.Graphics.ForeColor= bkColor
		  p.Graphics.FillRect 0, 0, p.Width, p.Height
		  
		  Dim s As RGBSurface= p.RGBSurface
		  
		  Dim cx As Integer= pWidth/ 2
		  Dim cy As Integer= cx
		  Dim radious As Integer= cx- offset
		  Dim rx, ry, d, g, u, v, w As Integer
		  Dim hue, sat, f As Double
		  'Dim pi As Double= 22/ 7
		  
		  For y As Integer= 0 To pWidth- 1
		    For x As Integer= 0 To pWidth- 1
		      rx= x- cx
		      ry= y- cy
		      d= rx* rx+ ry* ry
		      If d< (radious* radious) Then
		        hue= 6* (ATan2(rx, ry)+ kpi)/ (2* kpi)
		        sat= Sqrt(d)/ radious
		        g= Floor(hue)
		        f= hue- g
		        u= 255* (1- sat)
		        v= 255* (1- sat* f)
		        w= 255* (1- sat* (1- f))
		        Dim red() As Integer= Array(255, v, u, u, w, 255, 255)
		        Dim green() As Integer= Array(w, 255, 255, v, u, u, w)
		        Dim blue() As Integer= Array(u, u, w, 255, 255, v, u)
		        s.Pixel(x, y)= RGB(red(g), blue(g), green(g))
		      End If
		    Next
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Constructor()
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function DegreesToXY(degrees As Double, radius As Double) As Point
		  Dim xy As New Point
		  
		  Dim radians As Double= GetRadians(degrees)
		  
		  xy.X= Cos(radians)* radius
		  xy.Y= Sin(-radians)* radius
		  
		  return xy
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function EllipticalArc(x1 As Double, y1 As Double, rx As Double, ry As Double, theta As Double, flagA As Integer, flagS As Integer, x2 As Double, y2 As Double, borderColor As Color = &c00000000, borderWidth As Double = 1.5, border As Double = 100) As Group2D
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim fs As New Group2D
		  
		  Const DegToRad= 0.0174533
		  
		  // Step 1: Compute (x1', y1')
		  
		  Dim x1Comp As Double= cos(theta * DegToRad) * ((x1 - x2) / 2) +  sin(theta * DegToRad) * ((y1 - y2) / 2)
		  Dim y1Comp As Double= -sin(theta * DegToRad) * ((x1 - x2) / 2) +  cos(theta * DegToRad) * ((y1 - y2) / 2)
		  
		  // Step 2: Compute(cx', cy')
		  
		  Dim tmpDbl As Double= (rx^2 * ry^2) - (rx^2 * y1Comp^2) - (ry^2 * x1Comp^2)
		  tmpDbl= tmpDbl / ((rx^2 * y1Comp^2) + (ry^2 * x1Comp^2))
		  tmpDbl= Sqrt(Abs(tmpDbl))
		  
		  if flagA = flagS then
		    tmpDbl = -tmpDbl
		  end if
		  
		  Dim cxComp As Double= tmpDbl * (rx * y1Comp / ry)
		  Dim cyComp As Double= tmpDbl * -(ry * x1Comp / rx)
		  
		  // Step 3: Compute (cx, cy) from (cx', cy')
		  
		  Dim cx As Double= (cos(theta * DegToRad) * cxComp - sin(theta * DegToRad) * cyComp) + ((x1 + x2) / 2)
		  Dim cy As Double= (sin(theta * DegToRad) * cxComp + cos(theta * DegToRad) * cyComp) + ((y1 + y2) / 2)
		  
		  // Step 4: Compute theta1 and thetaDelta
		  
		  Dim u As New Point(1, 0)
		  Dim v As New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  Dim theta1 As Double= AngleBetweenVectors(u, v)
		  
		  u = New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  v = New Point((-x1Comp - cxComp) / rx, (-y1Comp - cyComp) / ry)
		  Dim thetaDelta As Double= AngleBetweenVectors(u, v)
		  thetaDelta = thetaDelta mod 360
		  
		  if (flagS = 0) and (thetaDelta > 0) then
		    thetaDelta = thetaDelta - 360
		  elseif (flagS = 1) and (thetaDelta < 0) then
		    thetaDelta = thetaDelta + 360
		  end if
		  
		  // Build path using calculated values
		  
		  Dim adjustValue As Double= thetaDelta / Abs(thetaDelta)
		  
		  Dim angleStep As Double= (thetaDelta / 360)
		  
		  Dim currentAngle As Double= theta1 + angleStep
		  
		  Dim penX As Double= x1
		  Dim peny As Double= y1
		  
		  while currentAngle * adjustValue < (theta1 + thetaDelta) * adjustValue
		    Dim cs As New CurveShape
		    cs.Border= border
		    cs.BorderColor= borderColor
		    cs.BorderWidth= borderWidth
		    
		    fs.Append cs
		    
		    Dim tmpX As Double= penX
		    Dim tmpY As Double= penY
		    cs.X = tmpX
		    cs.Y = tmpY
		    
		    if ((currentAngle + angleStep) * adjustValue) >= ((theta1 + thetaDelta) * adjustValue) then
		      tmpX = x2
		      tmpY = y2
		    else
		      tmpX = cx + rx * cos(currentAngle * DegToRad) // center a + radius x * cos(theta)
		      tmpY = cy + ry * sin(currentAngle * DegToRad) // center b + radius y * sin(theta)
		    end if
		    
		    penX = tmpX
		    penY = tmpY
		    cs.X2 = tmpX
		    cs.Y2 = tmpY
		    
		    currentAngle = currentAngle + angleStep
		    
		  wend
		  
		  Return fs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function EllipticalArc(x1 As Double, y1 As Double, rx As Double, ry As Double, theta As Double, flagA As Integer, flagS As Integer, x2 As Double, y2 As Double, borderColor As Color = &c00000000, borderWidth As Double = 1.5, border As Double = 100, matrix() As Double) As Group2D
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim fs As New Group2D
		  
		  Const DegToRad= 0.0174533
		  
		  // Step 1: Compute (x1', y1')
		  
		  Dim x1Comp As Double= cos(theta * DegToRad) * ((x1 - x2) / 2) +  sin(theta * DegToRad) * ((y1 - y2) / 2)
		  Dim y1Comp As Double= -sin(theta * DegToRad) * ((x1 - x2) / 2) +  cos(theta * DegToRad) * ((y1 - y2) / 2)
		  
		  // Step 2: Compute(cx', cy')
		  
		  Dim tmpDbl As Double= (rx^2 * ry^2) - (rx^2 * y1Comp^2) - (ry^2 * x1Comp^2)
		  tmpDbl= tmpDbl / ((rx^2 * y1Comp^2) + (ry^2 * x1Comp^2))
		  tmpDbl= Sqrt(Abs(tmpDbl))
		  
		  if flagA = flagS then
		    tmpDbl = -tmpDbl
		  end if
		  
		  Dim cxComp As Double= tmpDbl * (rx * y1Comp / ry)
		  Dim cyComp As Double= tmpDbl * -(ry * x1Comp / rx)
		  
		  // Step 3: Compute (cx, cy) from (cx', cy')
		  
		  Dim cx As Double= (cos(theta * DegToRad) * cxComp - sin(theta * DegToRad) * cyComp) + ((x1 + x2) / 2)
		  Dim cy As Double= (sin(theta * DegToRad) * cxComp + cos(theta * DegToRad) * cyComp) + ((y1 + y2) / 2)
		  
		  // Step 4: Compute theta1 and thetaDelta
		  
		  Dim u As New Point(1, 0)
		  Dim v As New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  Dim theta1 As Double= AngleBetweenVectors(u, v)
		  
		  u = New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  v = New Point((-x1Comp - cxComp) / rx, (-y1Comp - cyComp) / ry)
		  Dim thetaDelta As Double= AngleBetweenVectors(u, v)
		  thetaDelta = thetaDelta mod 360
		  
		  if (flagS = 0) and (thetaDelta > 0) then
		    thetaDelta = thetaDelta - 360
		  elseif (flagS = 1) and (thetaDelta < 0) then
		    thetaDelta = thetaDelta + 360
		  end if
		  
		  // Build path using calculated values
		  
		  Dim adjustValue As Double= thetaDelta / Abs(thetaDelta)
		  
		  Dim angleStep As Double= (thetaDelta / 360)
		  
		  Dim currentAngle As Double= theta1 + angleStep
		  
		  Dim penX As Double= x1
		  Dim peny As Double= y1
		  
		  while currentAngle * adjustValue < (theta1 + thetaDelta) * adjustValue
		    Dim cs As New CurveShape
		    cs.Border= border
		    cs.BorderColor= borderColor
		    cs.BorderWidth= borderWidth
		    
		    fs.Append cs
		    
		    Dim tmpX As Double= penX
		    Dim tmpY As Double= penY
		    TransformPoint tmpX, tmpY, matrix
		    cs.X = tmpX
		    cs.Y = tmpY
		    
		    if ((currentAngle + angleStep) * adjustValue) >= ((theta1 + thetaDelta) * adjustValue) then
		      tmpX = x2
		      tmpY = y2
		    else
		      tmpX = cx + rx * cos(currentAngle * DegToRad) // center a + radius x * cos(theta)
		      tmpY = cy + ry * sin(currentAngle * DegToRad) // center b + radius y * sin(theta)
		    end if
		    
		    penX = tmpX
		    penY = tmpY
		    TransformPoint tmpX, tmpY, matrix
		    cs.X2 = tmpX
		    cs.Y2 = tmpY
		    
		    currentAngle = currentAngle + angleStep
		    
		  wend
		  
		  Return fs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function EllipticalArcFill(x1 As Double, y1 As Double, rx As Double, ry As Double, theta As Double, flagA As Integer, flagS As Integer, x2 As Double, y2 As Double) As FigureShape
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim fs As New FigureShape
		  
		  Const DegToRad= 0.0174533
		  
		  // Step 1: Compute (x1', y1')
		  
		  Dim x1Comp As Double= cos(theta * DegToRad) * ((x1 - x2) / 2) +  sin(theta * DegToRad) * ((y1 - y2) / 2)
		  Dim y1Comp As Double= -sin(theta * DegToRad) * ((x1 - x2) / 2) +  cos(theta * DegToRad) * ((y1 - y2) / 2)
		  
		  // Step 2: Compute(cx', cy')
		  
		  Dim tmpDbl As Double= (rx^2 * ry^2) - (rx^2 * y1Comp^2) - (ry^2 * x1Comp^2)
		  tmpDbl= tmpDbl / ((rx^2 * y1Comp^2) + (ry^2 * x1Comp^2))
		  tmpDbl= Sqrt(Abs(tmpDbl))
		  
		  if flagA = flagS then
		    tmpDbl = -tmpDbl
		  end if
		  
		  Dim cxComp As Double= tmpDbl * (rx * y1Comp / ry)
		  Dim cyComp As Double= tmpDbl * -(ry * x1Comp / rx)
		  
		  // Step 3: Compute (cx, cy) from (cx', cy')
		  
		  Dim cx As Double= (cos(theta * DegToRad) * cxComp - sin(theta * DegToRad) * cyComp) + ((x1 + x2) / 2)
		  Dim cy As Double= (sin(theta * DegToRad) * cxComp + cos(theta * DegToRad) * cyComp) + ((y1 + y2) / 2)
		  
		  // Step 4: Compute theta1 and thetaDelta
		  
		  Dim u As New Point(1, 0)
		  Dim v As New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  Dim theta1 As Double= AngleBetweenVectors(u, v)
		  
		  u = New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  v = New Point((-x1Comp - cxComp) / rx, (-y1Comp - cyComp) / ry)
		  Dim thetaDelta As Double= AngleBetweenVectors(u, v)
		  thetaDelta = thetaDelta mod 360
		  
		  if (flagS = 0) and (thetaDelta > 0) then
		    thetaDelta = thetaDelta - 360
		  elseif (flagS = 1) and (thetaDelta < 0) then
		    thetaDelta = thetaDelta + 360
		  end if
		  
		  // Build path using calculated values
		  
		  Dim adjustValue As Double= thetaDelta / Abs(thetaDelta)
		  
		  Dim angleStep As Double= (thetaDelta / 360)
		  
		  Dim currentAngle As Double= theta1 + angleStep
		  
		  Dim penX As Double= x1
		  Dim peny As Double= y1
		  
		  while currentAngle * adjustValue < (theta1 + thetaDelta) * adjustValue
		    Static cs1st As CurveShape
		    If cs1st= Nil Then
		      cs1st= New CurveShape
		      cs1st.X= cx
		      cs1st.Y= cy
		      cs1st.X2= x1
		      cs1st.Y2= y1
		      cs1st.BorderWidth= 1.5
		      
		      fs.Append cs1st
		    End If
		    
		    Dim cs As New CurveShape
		    cs.BorderWidth= 1.5
		    
		    fs.Append cs
		    
		    Dim tmpX As Double= penX
		    Dim tmpY As Double= penY
		    cs.X = tmpX
		    cs.Y = tmpY
		    
		    if ((currentAngle + angleStep) * adjustValue) >= ((theta1 + thetaDelta) * adjustValue) then
		      tmpX = x2
		      tmpY = y2
		    else
		      tmpX = cx + rx * cos(currentAngle * DegToRad) // center a + radius x * cos(theta)
		      tmpY = cy + ry * sin(currentAngle * DegToRad) // center b + radius y * sin(theta)
		    end if
		    
		    penX = tmpX
		    penY = tmpY
		    cs.X2 = tmpX
		    cs.Y2 = tmpY
		    
		    currentAngle = currentAngle + angleStep
		    
		  wend
		  
		  Return fs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub EllipticalArcFill(fs As FigureShape, x1 As Double, y1 As Double, rx As Double, ry As Double, theta As Double, flagA As Integer, flagS As Integer, x2 As Double, y2 As Double)
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  'Dim fs As New FigureShape
		  
		  Const DegToRad= 0.0174533
		  
		  // Step 1: Compute (x1', y1')
		  
		  Dim x1Comp As Double= cos(theta * DegToRad) * ((x1 - x2) / 2) +  sin(theta * DegToRad) * ((y1 - y2) / 2)
		  Dim y1Comp As Double= -sin(theta * DegToRad) * ((x1 - x2) / 2) +  cos(theta * DegToRad) * ((y1 - y2) / 2)
		  
		  // Step 2: Compute(cx', cy')
		  
		  Dim tmpDbl As Double= (rx^2 * ry^2) - (rx^2 * y1Comp^2) - (ry^2 * x1Comp^2)
		  tmpDbl= tmpDbl / ((rx^2 * y1Comp^2) + (ry^2 * x1Comp^2))
		  tmpDbl= Sqrt(Abs(tmpDbl))
		  
		  if flagA = flagS then
		    tmpDbl = -tmpDbl
		  end if
		  
		  Dim cxComp As Double= tmpDbl * (rx * y1Comp / ry)
		  Dim cyComp As Double= tmpDbl * -(ry * x1Comp / rx)
		  
		  // Step 3: Compute (cx, cy) from (cx', cy')
		  
		  Dim cx As Double= (cos(theta * DegToRad) * cxComp - sin(theta * DegToRad) * cyComp) + ((x1 + x2) / 2)
		  Dim cy As Double= (sin(theta * DegToRad) * cxComp + cos(theta * DegToRad) * cyComp) + ((y1 + y2) / 2)
		  
		  // Step 4: Compute theta1 and thetaDelta
		  
		  Dim u As New Point(1, 0)
		  Dim v As New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  Dim theta1 As Double= AngleBetweenVectors(u, v)
		  
		  u = New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  v = New Point((-x1Comp - cxComp) / rx, (-y1Comp - cyComp) / ry)
		  Dim thetaDelta As Double= AngleBetweenVectors(u, v)
		  thetaDelta = thetaDelta mod 360
		  
		  if (flagS = 0) and (thetaDelta > 0) then
		    thetaDelta = thetaDelta - 360
		  elseif (flagS = 1) and (thetaDelta < 0) then
		    thetaDelta = thetaDelta + 360
		  end if
		  
		  // Build path using calculated values
		  
		  Dim adjustValue As Double= thetaDelta / Abs(thetaDelta)
		  
		  Dim angleStep As Double= (thetaDelta / 360)
		  
		  Dim currentAngle As Double= theta1 + angleStep
		  
		  Dim penX As Double= x1
		  Dim peny As Double= y1
		  
		  while currentAngle * adjustValue < (theta1 + thetaDelta) * adjustValue
		    Static cs1st As CurveShape
		    If cs1st= Nil Then
		      cs1st= New CurveShape
		      cs1st.X= cx
		      cs1st.Y= cy
		      cs1st.X2= x1
		      cs1st.Y2= y1
		      cs1st.BorderWidth= 1.5
		      
		      fs.Append cs1st
		    End If
		    
		    Dim cs As New CurveShape
		    cs.BorderWidth= 1.5
		    
		    fs.Append cs
		    
		    Dim tmpX As Double= penX
		    Dim tmpY As Double= penY
		    cs.X = tmpX
		    cs.Y = tmpY
		    
		    if ((currentAngle + angleStep) * adjustValue) >= ((theta1 + thetaDelta) * adjustValue) then
		      tmpX = x2
		      tmpY = y2
		    else
		      tmpX = cx + rx * cos(currentAngle * DegToRad) // center a + radius x * cos(theta)
		      tmpY = cy + ry * sin(currentAngle * DegToRad) // center b + radius y * sin(theta)
		    end if
		    
		    penX = tmpX
		    penY = tmpY
		    cs.X2 = tmpX
		    cs.Y2 = tmpY
		    
		    currentAngle = currentAngle + angleStep
		    
		  wend
		  
		  'Return fs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub EllipticalArcFill(fs As FigureShape, x1 As Double, y1 As Double, rx As Double, ry As Double, theta As Double, flagA As Integer, flagS As Integer, x2 As Double, y2 As Double, matrix() As Double)
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  'Dim fs As New FigureShape
		  
		  Const DegToRad= 0.0174533
		  
		  // Step 1: Compute (x1', y1')
		  
		  Dim x1Comp As Double= cos(theta * DegToRad) * ((x1 - x2) / 2) +  sin(theta * DegToRad) * ((y1 - y2) / 2)
		  Dim y1Comp As Double= -sin(theta * DegToRad) * ((x1 - x2) / 2) +  cos(theta * DegToRad) * ((y1 - y2) / 2)
		  
		  // Step 2: Compute(cx', cy')
		  
		  Dim tmpDbl As Double= (rx^2 * ry^2) - (rx^2 * y1Comp^2) - (ry^2 * x1Comp^2)
		  tmpDbl= tmpDbl / ((rx^2 * y1Comp^2) + (ry^2 * x1Comp^2))
		  tmpDbl= Sqrt(Abs(tmpDbl))
		  
		  if flagA = flagS then
		    tmpDbl = -tmpDbl
		  end if
		  
		  Dim cxComp As Double= tmpDbl * (rx * y1Comp / ry)
		  Dim cyComp As Double= tmpDbl * -(ry * x1Comp / rx)
		  
		  // Step 3: Compute (cx, cy) from (cx', cy')
		  
		  Dim cx As Double= (cos(theta * DegToRad) * cxComp - sin(theta * DegToRad) * cyComp) + ((x1 + x2) / 2)
		  Dim cy As Double= (sin(theta * DegToRad) * cxComp + cos(theta * DegToRad) * cyComp) + ((y1 + y2) / 2)
		  
		  // Step 4: Compute theta1 and thetaDelta
		  
		  Dim u As New Point(1, 0)
		  Dim v As New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  Dim theta1 As Double= AngleBetweenVectors(u, v)
		  
		  u = New Point((x1Comp - cxComp) / rx, (y1Comp - cyComp) / ry)
		  v = New Point((-x1Comp - cxComp) / rx, (-y1Comp - cyComp) / ry)
		  Dim thetaDelta As Double= AngleBetweenVectors(u, v)
		  thetaDelta = thetaDelta mod 360
		  
		  if (flagS = 0) and (thetaDelta > 0) then
		    thetaDelta = thetaDelta - 360
		  elseif (flagS = 1) and (thetaDelta < 0) then
		    thetaDelta = thetaDelta + 360
		  end if
		  
		  // Build path using calculated values
		  
		  Dim adjustValue As Double= thetaDelta / Abs(thetaDelta)
		  
		  Dim angleStep As Double= (thetaDelta / 360)
		  
		  Dim currentAngle As Double= theta1 + angleStep
		  
		  Dim penX As Double= x1
		  Dim peny As Double= y1
		  
		  while currentAngle * adjustValue < (theta1 + thetaDelta) * adjustValue
		    Static cs1st As CurveShape
		    If cs1st= Nil Then
		      cs1st= New CurveShape
		      cs1st.X= cx
		      cs1st.Y= cy
		      cs1st.X2= x1
		      cs1st.Y2= y1
		      cs1st.BorderWidth= 1.5
		      
		      fs.Append cs1st
		    End If
		    
		    Dim cs As New CurveShape
		    cs.BorderWidth= 1.5
		    
		    fs.Append cs
		    
		    Dim tmpX As Double= penX
		    Dim tmpY As Double= penY
		    TransformPoint tmpX, tmpY, matrix
		    cs.X = tmpX
		    cs.Y = tmpY
		    
		    if ((currentAngle + angleStep) * adjustValue) >= ((theta1 + thetaDelta) * adjustValue) then
		      tmpX = x2
		      tmpY = y2
		    else
		      tmpX = cx + rx * cos(currentAngle * DegToRad) // center a + radius x * cos(theta)
		      tmpY = cy + ry * sin(currentAngle * DegToRad) // center b + radius y * sin(theta)
		    end if
		    
		    penX = tmpX
		    penY = tmpY
		    TransformPoint tmpX, tmpY, matrix
		    cs.X2 = tmpX
		    cs.Y2 = tmpY
		    
		    currentAngle = currentAngle + angleStep
		    
		  wend
		  
		  'Return fs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function GetColorPct(points() As Pair, pct As Double) As Color
		  // sanity chk
		  If points.Ubound= -1 Then Return RGB(0, 0, 0)
		  If points.Ubound= 0 Then Return points(0).Right.ColorValue
		  
		  Const nDecim= 10000 // 4 decimal places
		  
		  Dim pointOne, pointTwo As pair
		  Dim colorOne, colorTwo, blendedColor As Color
		  pct= Round(pct* nDecim)/ nDecim
		  
		  For i As Integer= 0 To points.Ubound- 1
		    pointOne= points(i)
		    pointTwo= points(i+ 1)
		    
		    Dim pointOneLeft As Double= Round(pointOne.Left.DoubleValue* nDecim)/ nDecim
		    Dim pointTwoLeft As Double= Round(pointTwo.Left.DoubleValue* nDecim)/ nDecim
		    
		    If pointOneLeft<= pct And pointTwoLeft>= pct Then
		      colorOne= pointone.Right
		      colorTwo= pointtwo.Right
		      
		      Dim pctColor As Double= (pct- pointOneLeft)/ (pointTwoLeft- pointOneLeft)
		      pctColor= Round(pctColor* nDecim)/ nDecim
		      
		      blendedcolor= RGB((colorOne.Red* (1- pctColor))+ (colorTwo.Red* pctColor), _
		      (colorOne.Green* (1- pctColor))+ (colorTwo.Green* pctColor), _
		      (colorOne.Blue* (1- pctColor))+ (colorTwo.blue* pctColor), _
		      (colorOne.Alpha* (1- pctColor))+ (colorTwo.Alpha* pctColor))
		      
		      'System.DebugLog Format(pct, "0.00000000")+ ","+ Str(colorOne)+ ","+ Str(colorTwo)+ ","+ _
		      'Format(pctColor, "0.00000000")+ ","+ Str(blendedColor)
		      Return blendedColor
		    End If
		    
		  Next
		  
		  Return points(0).Right.ColorValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetContrastColor(colr As Color, darkColor As Color, lightColor As Color) As Color
		  Dim yiq As Integer= (colr.Red* 299+ colr.Green* 587+ colr.Blue+ 114)/ 1000
		  If yiq>= 131.5 Then Return darkColor Else Return lightColor
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetDegrees(radians As Double) As Double
		  Return radians* 180/ kPI
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetRadians(degrees As Double) As Double
		  Return degrees* kPI/ 180
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetRotatedBounds(r As Rect, angle As Double) As Rect
		  If r Is Nil Then Return New Rect
		  If angle= 0 Then Return r
		  
		  Dim point1 As Point= GetRotatedPoint(r.Left, r.Top, r.Center.X, r.Center.Y, angle)
		  Dim point2 As Point= GetRotatedPoint(r.Right, r.Top, r.Center.X, r.Center.Y, angle)
		  Dim point3 As Point= GetRotatedPoint(r.Right, r.Bottom, r.Center.X, r.Center.Y, angle)
		  Dim point4 As Point= GetRotatedPoint(r.Left, r.bottom, r.Center.X, r.Center.Y, angle)
		  
		  Dim left As Double= Min(point1.X, point2.X, point3.X, point4.X)
		  Dim top As Double= Min(point1.Y, point2.Y, point3.Y, point4.Y)
		  Dim right As Double= Max(point1.X, point2.X, point3.X, point4.X)
		  Dim bottom As Double= Max(point1.Y, point2.Y, point3.Y, point4.Y)
		  
		  Return New Rect(left, top, right- left, bottom- top)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GetRotatedPoint(x As Double, y As Double, cx As Double, cy As Double, a As Double) As Point
		  If a= 0 Then
		    Return New Point(x, y)
		  Else
		    Dim r As Double= Sqrt((x- cx)^ 2+ (y- cy)^ 2) // radius using distance formula
		    
		    Dim iA As Double= Atan2((y- cy), (x- cx)) // initial angle in relation to center
		    
		    Dim nx As Integer= Round(r* Cos(a+ iA))
		    Dim ny As Integer= Round(r* Sin(a+ iA))
		    
		    Return New Point(cx+ nx, cy+ ny)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GradientLinear(width As Single, height As Single, points() As Pair, vertical As Boolean = True, chessboard As Boolean = False) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As New Picture(width, height)
		  Dim g As Graphics= p.Graphics
		  
		  If chessboard Then
		    Dim firstColor As Color
		    
		    For xx As Integer= 0 To width+ kAphaColorSize Step kAphaColorSize
		      For yy As Integer= 0 To height+ kAphaColorSize Step kAphaColorSize
		        If g.ForeColor= kAphaColorOdd Then g.ForeColor= kAphaColorEven Else g.ForeColor= kAphaColorOdd
		        g.FillRect xx, yy, kAphaColorSize, kAphaColorSize
		        If yy= 0 Then firstColor= g.ForeColor
		      Next
		      If g.ForeColor<> firstColor Then
		        If g.ForeColor= kAphaColorOdd Then g.ForeColor= kAphaColorEven Else g.ForeColor= kAphaColorOdd
		      End If
		    Next
		  End If
		  
		  dim i,x,w,nextstart as integer
		  dim pointOne,pointTwo as pair
		  dim colorOne,colorTwo,blendedColor as color
		  dim pct as double
		  
		  for i = 0 to ubound(points) - 1
		    pointone = points(i)
		    pointtwo = points(i + 1)
		    colorone = pointone.right
		    colortwo = pointtwo.right
		    if vertical then
		      w = (pointtwo.left.doublevalue * height) - nextstart
		    else
		      w = (pointtwo.left.doublevalue * width) - nextstart
		    end
		    
		    for x = 0 to w
		      pct = x / w
		      blendedcolor = rgb((colorone.red * (1 - pct)) + (colortwo.red * pct),(colorone.green * (1 - pct)) + (colortwo.green * pct),_
		      (colorone.blue * (1 - pct)) + (colortwo.blue * pct), (colorOne.Alpha* (1- pct))+ (colorTwo.Alpha* pct))
		      g.forecolor = blendedcolor
		      if vertical then
		        g.drawline(-1,x + nextstart,p.width + 1,x + nextstart)
		      else
		        g.drawline(x + nextstart,-1,x + nextstart,p.height + 1)
		      end
		    next
		    
		    nextstart = nextstart + w
		  next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GradientLinearR(width As Single, height As Single, points() As Pair, degrees As Single) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim pWidth As Integer= width
		  Dim pHeight As Integer= height
		  Dim rotation As Double= ToRadians(degrees)
		  
		  If (degrees Mod 90)<> 0 Then
		    pWidth= Abs((Cos(rotation)* width)+ (Cos((kPI/ 2)- rotation)* height))
		    pHeight= Abs((Cos(rotation)* height)+ (Cos((kPI/ 2)- rotation)* width))
		  Else
		    pWidth= height
		    pHeight= width
		  End If
		  
		  Dim p As New Picture(pWidth, pHeight)
		  Dim g As Graphics= p.Graphics
		  
		  For y As Integer= 0 To pHeight
		    Dim pct As Double= y/ pHeight
		    
		    g.ForeColor= GetColorPct(points, pct)
		    g.DrawLine 0, y, g.Width, y
		  Next
		  
		  Dim px As New PixmapShape(p)
		  px.Rotation= rotation
		  
		  Return px
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GradientRadial(width As Single, height As Single, points() As Pair) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #If Not DebugBuild
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As New Picture(width, height)
		  Dim s As RGBSurface= p.RGBSurface
		  
		  Dim diag As Double= sqrt((width/ 2)^ 2+ (height/ 2)^ 2)
		  Dim deltaX As Integer= diag- (width/ 2)
		  Dim deltaY As Integer= diag- (height/ 2)
		  
		  Dim cx As Single= (width+ (deltaX* 2))/ 2
		  Dim cy As Single= (height+ (deltaY* 2))/ 2
		  
		  For x As Integer= 0 To width+ (deltaX* 2)
		    For y As Integer= 0 To height+ (deltaX* 2)
		      Dim fact As Double= (((x- cx)^ 2)/ cx^ 2)+ (((y- cy)^ 2)/ cy^2)
		      
		      If fact<= 1 Then // in oval
		        s.Pixel(x- deltaX, y- deltaY)= GetColorPct(points, fact)
		      End If
		    Next
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function GradientRadialIn(width As Single, height As Single, points() As Pair) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #If Not DebugBuild
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As New Picture(width, height)
		  Dim s As RGBSurface= p.RGBSurface
		  
		  Dim cx As Single= width/ 2
		  Dim cy As Single= height/ 2
		  
		  For x As Integer= 0 To width
		    For y As Integer= 0 To height
		      Dim fact As Double= (((x- cx)^ 2)/ cx^ 2)+ (((y- cy)^ 2)/ cy^2)
		      
		      If fact<= 1 Then // in oval
		        s.Pixel(x, y)= GetColorPct(points, fact)
		      End If
		    Next
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Grid(width As Integer, height As Integer, gridSizeX As Integer = 10, gridSizeY As Integer = 10, fillColr As Color = &cFFFFFF00, lineColr1 As Color = &cFAFAFA00, lineColr2 As Color = &cF0F0F000) As PixmapShape
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If width< 1 Then width= 1
		  If width> 32767 Then width= 32767
		  If height< 1 Then height= 1
		  If height> 32767 Then height= 32767
		  
		  Dim p As New Picture(width, height, 32)
		  Dim g As Graphics= p.Graphics
		  
		  g.ForeColor= fillColr
		  g.FillRect 0, 0, g.Width, g.Height
		  
		  g.ForeColor= lineColr1
		  For i As Integer= 0 To g.Width Step gridSizeX
		    g.DrawLine i, 0, i, g.Height
		  Next
		  For j As Integer= 0 To g.Height Step gridSizeY
		    g.DrawLine 0, j, g.Width, j
		  Next
		  
		  g.ForeColor= lineColr2
		  For i As Integer= 0 To g.Width Step gridSizeX* 4
		    g.DrawLine i, 0, i, g.Height
		  Next
		  For j As Integer= 0 To g.Height Step gridSizeY* 4
		    g.DrawLine 0, j, g.Width, j
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function IsLeft(p0 As Point, p1 As Point, p2 As Point) As Integer
		  Return ( (p1.X - p0.X) * (p2.Y - p0.Y) - (p2.X -  p0.X) * (p1.Y - p0.Y) )
		  
		  // isLeft(): tests if a point is Left|On|Right of an infinite line.
		  //    Input:  three points P0, P1, and P2
		  //    Return: >0 for P2 left of the line through P0 and P1
		  //            =0 for P2  on the line
		  //            <0 for P2  right of the line
		  //    See: Algorithm 1 "Area of Triangles and Polygons"
		  
		  // http://geomalgorithms.com/a03-_inclusion.html
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function LinePattern(x1 As Double, y1 As Double, x2 As Double, y2 As Double, lengths() As Integer) As Group2D
		  'LBMSoft.Debug.Assert (lengths.Ubound> -1)
		  
		  Dim lengthsD() As Double
		  
		  For i As Integer= 0 To lengths.Ubound
		    lengthsD.Append lengths(i)
		  Next
		  
		  Return LinePattern(x1, y1, x2, y2, Patterns.Dashed, Nil, lengthsD)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function LinePattern(x1 As Double, y1 As Double, x2 As Double, y2 As Double, pattern As Patterns = Shape2D.Patterns.Dashed, Optional style As Object2D, Optional lengths() As Double) As Group2D
		  #pragma BackgroundTasks False
		  
		  'LBMSoft.Debug.Assert (True)
		  
		  If lengths Is Nil Then
		    If pattern= Patterns.Dashed Then
		      lengths= Array(8.0, 4.0)
		    ElseIf pattern= Patterns.Dotted Then
		      lengths= Array(2.0, 6.0)
		    Else
		      lengths= Array(6.0, 0.0)
		    End If
		  End If
		  
		  Dim distance As Double= sqrt((x2- x1)^ 2+ (y2- y1)^ 2)
		  Dim angle As Double= Atan2(y2- y1, x2- x1)
		  
		  Dim lengthStep As Double
		  For i As Integer= 0 To lengths.Ubound
		    lengthStep= lengthStep+ lengths(i)
		  Next
		  If lengthStep= 0 Then lengthStep= 6
		  
		  Dim xIni As Double= x1
		  Dim yIni As Double= y1
		  Dim shape As New Group2D
		  
		  For i As Double= 0 To distance Step lengthStep
		    Dim xIniLength As Double= xIni
		    Dim yIniLength As Double= yIni
		    
		    For j As Integer= 0 To lengths.Ubound
		      If ((j+ 1) Mod 2)= 0 Then // even
		      ElseIf xIniLength< (x1+ distance) And yIniLength< (y1+ distance) Then // odd
		        Dim line1 As New CurveShape
		        
		        If style<> Nil Then
		          line1.Border= style.Border
		          line1.BorderWidth= style.BorderWidth
		          line1.BorderColor= style.BorderColor
		          line1.Fill= style.Fill
		          line1.FillColor= style.FillColor
		        End If
		        
		        line1.X= xIniLength
		        line1.Y= yIniLength
		        line1.X2= xIniLength+ lengths(j)* Cos(angle)
		        line1.Y2= yIniLength+ lengths(j)* Sin(angle)
		        
		        If line1.X2> (x1+ distance) Then line1.X2= x1+ distance
		        If line1.Y2> (y1+ distance) Then line1.Y2= y1+ distance
		        
		        shape.Append line1
		      End If
		      xIniLength= xIniLength+ lengths(j)* Cos(angle)
		      yIniLength= yIniLength+ lengths(j)* Sin(angle)
		    Next
		    
		    xIni= xIni+ lengthStep* Cos(angle)
		    yIni= yIni+ lengthStep* Sin(angle)
		    
		  Next
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Noise(width As Integer, height As Integer, bgColor As Color = &cF9FAFB00, rangeIni As Double, rangeEnd As Double, density As Integer = 2, dark As Boolean = True) As PixmapShape
		  #pragma BackgroundTasks false // to speed up
		  
		  'LBMSoft.Debug.Assert (width> 0 And height> 0)
		  
		  #if TargetWin32 And RBVersion< 2016.04 And Not TargetConsole
		    App.UseGDIPlus= True
		  #endif
		  
		  // sanity chk
		  If Width< 1 Or Height< 1 Then Return New PixmapShape(New Picture(1, 1))
		  If density< 1 Then density= 1
		  
		  Dim r As Random= Randomize
		  
		  Dim p As New Picture(width, height)
		  Dim g As Graphics= p.Graphics
		  
		  g.ForeColor= bgColor
		  g.FillRect 0, 0, width, height
		  
		  For x As Integer= 0 To g.Width Step density
		    For y As Integer= 0 To g.Height Step density
		      Dim saturation, saturationMin, saturationMax As Double
		      saturationMin= bgColor.Saturation- 0.04
		      If saturationMin< 0 Then saturationMin= 0
		      saturationMax= bgColor.Saturation+ 0.04
		      If saturationMax> 1 Then saturationMax= 1
		      saturation= r.InRange(saturationMin* 100, saturationMax* 100)/ 100
		      
		      Dim colr As Color= bgColor
		      Dim factor As Double= r.InRange(rangeIni* 1000, rangeEnd* 1000)/ 1000
		      
		      If dark Then
		        If r.InRange(0, 100)< 2 Then colr= HSV(bgColor.Hue, saturation, bgColor.Value) // sature
		        colr= RGB(colr.Red/ factor, colr.Green/ factor, colr.Blue/ factor, bgColor.Alpha) // darker
		        g.ForeColor= colr
		      Else
		        If r.InRange(0, 100)< 2 Then colr= HSV(bgColor.Hue, saturation, bgColor.Value) // sature
		        
		        Dim factorRed As Integer= colr.Red* factor
		        If factorRed> 255 Then factorRed= 255
		        
		        Dim factorGreen As Integer= colr.Green* factor
		        If factorGreen> 255 Then factorGreen= 255
		        
		        Dim factorBlue As Integer= colr.Blue* factor
		        If factorBlue> 255 Then factorBlue= 255
		        
		        g.ForeColor= RGB(factorRed, factorGreen, factorBlue, bgColor.Alpha) // brighter
		      End
		      g.FillRect x, y, density, density
		    Next
		  Next
		  
		  Return New PixmapShape(p)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Oval(cx As Double, cy As Double, r As Double, matrix() As Double, lineStyle As Object2D = Nil) As Group2D
		  Return Oval(cx, cy, r, r, matrix, lineStyle)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Oval(cx As Double, cy As Double, rx As Double, ry As Double, matrix() As Double, lineStyle As Object2D = Nil) As Group2D
		  ' This project is a {Zoclee}™ open source initiative.
		  ' www.zoclee.com
		  
		  Dim shape As New Group2D
		  
		  If rx< 1 Or ry< 1 Then Return shape
		  
		  // build polygon
		  
		  Dim points() As Double
		  Dim pointCount As Integer= (((rx+ ry)/ 2)* 180)/ 50
		  Dim i As Integer
		  
		  While i <= pointCount
		    Dim theta As Double= kPi* (i/ (pointCount/ 2))
		    
		    Dim tmpX As Double= cx+ rx* Cos(theta) // center a + radius x * cos(theta)
		    Dim tmpY As Double= cy+ ry* Sin(theta) // center b + radius y * sin(theta)
		    TransformPoint tmpX, tmpY, matrix
		    
		    points.Append tmpX
		    points.Append tmpY
		    i= i + 1
		  Wend
		  
		  If lineStyle<> Nil And lineStyle.Fill<> 0 Then // filled
		    Dim line As New FigureShape
		    
		    For j As Integer= 0 To points.Ubound- 2 Step 2
		      Dim x, y, x2, y2 As Double
		      x= points(j)
		      If (j+ 1)<= points.Ubound Then y= points(j+ 1)
		      If (j+ 2)<= points.Ubound Then x2= points(j+ 2)
		      If (j+ 3)<= points.Ubound Then y2= points(j+ 3)
		      
		      line.AddLine x, y, x2, y2
		    Next
		    
		    line.Border= lineStyle.Border
		    line.BorderColor= lineStyle.BorderColor
		    line.BorderWidth= lineStyle.BorderWidth
		    line.Fill= lineStyle.Fill
		    line.FillColor= lineStyle.FillColor
		    
		    shape.Append line
		  Else
		    For j As Integer= 0 To points.Ubound- 2 Step 2
		      Dim line As New CurveShape
		      line.X= points(j)
		      If (j+ 1)<= points.Ubound Then line.Y= points(j+ 1)
		      If (j+ 2)<= points.Ubound Then line.X2= points(j+ 2)
		      If (j+ 3)<= points.Ubound Then line.Y2= points(j+ 3)
		      
		      If lineStyle<> Nil Then
		        line.Border= lineStyle.Border
		        line.BorderColor= lineStyle.BorderColor
		        line.BorderWidth= lineStyle.BorderWidth
		        line.Fill= lineStyle.Fill
		        line.FillColor= lineStyle.FillColor
		      End If
		      
		      shape.Append line
		    Next
		  End If
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function PointInControl(x As Integer, y As Integer, ctrl As RectControl) As Boolean
		  Dim rect As New REALbasic.Rect(ctrl.Left, ctrl.Top, ctrl.width, ctrl.Height)
		  If rect.Contains(New REALbasic.Point(ctrl.Left+ x, ctrl.Top+ y)) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function PointInControl(x As Integer, y As Integer, ctrl As Window) As Boolean
		  Dim rect As New REALbasic.Rect(ctrl.Left, ctrl.Top, ctrl.width, ctrl.Height)
		  If rect.Contains(New REALbasic.Point(ctrl.Left+ x, ctrl.Top+ y)) Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function PointInPoint(xP As Point, aP As Point, bP As Point, cP As Point, dP As Point) As Boolean
		  Dim a1 As Double= Sqrt((aP.X- bP.X)^2+ (aP.Y- bP.Y)^2)
		  Dim a2 As Double= Sqrt((bP.X- cP.X)^2+ (bP.Y- cP.Y)^2)
		  Dim a3 As Double= Sqrt((cP.X- dP.X)^2+ (cP.Y- dP.Y)^2)
		  Dim a4 As Double= Sqrt((dP.X- aP.X)^2+ (dP.Y- aP.Y)^2)
		  
		  Dim b1 As Double= Sqrt((aP.X- xP.X)^2+ (aP.Y- xP.Y)^2)
		  Dim b2 As Double= Sqrt((bP.X- xP.X)^2+ (bP.Y- xP.Y)^2)
		  Dim b3 As Double= Sqrt((cP.X- xP.X)^2+ (cP.Y- xP.Y)^2)
		  Dim b4 As Double= Sqrt((dP.X- xP.X)^2+ (dP.Y- xP.Y)^2)
		  
		  Dim u1 As Double= (a1+ b1+ b2)/ 2
		  Dim u2 As Double= (a2+ b2+ b3)/ 2
		  Dim u3 As Double= (a3+ b3+ b4)/ 2
		  Dim u4 As Double= (a4+ b4+ b1)/ 2
		  
		  Dim aaT As Double= a1* a2
		  
		  Dim aa1 As Double= Sqrt(u1* (u1- a1)* (u1- b1)* (u1- b2))
		  Dim aa2 As Double= Sqrt(u2* (u2- a2)* (u2- b2)* (u2- b3))
		  Dim aa3 As Double= Sqrt(u3* (u3- a3)* (u3- b3)* (u3- b4))
		  Dim aa4 As Double= Sqrt(u4* (u4- a4)* (u4- b4)* (u4- b1))
		  
		  If Abs(aaT- (aa1+ aa2+ aa3+ aa4))<= 0.001 Then Return True
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function PointInPolyCN(pnt As Point, verts() As Point) As Boolean
		  Dim cn As Integer    // the  crossing number counter
		  
		  // loop through all edges of the polygon
		  For i As Integer= 0 To verts.Ubound- 1    // edge from V[i]  to V[i+1]
		    If (verts(i).Y <= pnt.Y And verts(i+ 1).Y> pnt.Y) Or _     // an upward crossing
		      (verts(i).Y> pnt.Y And verts(i+ 1).Y<= pnt.Y) Then    // a downward crossing
		      // compute  the actual edge-ray intersect x-coordinate
		      Dim vt As Double= (pnt.Y- verts(i).Y)/ (verts(i+ 1).Y- verts(i).Y)
		      If (pnt.X<  verts(i).X+ vt* (verts(i+ 1).X- verts(i).X)) Then    // P.x < intersect
		        cn= cn+ 1    // a valid crossing of y=P.y right of P.x
		      End If
		    End If
		  Next
		  
		  Return (BitwiseAnd(cn, 1)= 1)    // 0 if even (out), and 1 if  odd (in)
		  
		  // Copyright 2000 softSurfer, 2012 Dan Sunday
		  // This code may be freely used and modified for any purpose
		  // providing that this copyright notice is included with it.
		  // SoftSurfer makes no warranty for this code, and cannot be held
		  // liable for any real or imagined damage resulting from its use.
		  // Users of this code must verify correctness for their application.
		  
		  // cn_PnPoly(): crossing number test for a point in a polygon
		  //      Input:   P = a point,
		  //               V[] = vertex points of a polygon V[n+1] with V[n]=V[0]
		  //      Return:  0 = outside, 1 = inside
		  // This code is patterned after [Franklin, 2000]
		  
		  // http://geomalgorithms.com/a03-_inclusion.html
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function PointInPolyWN(pnt As Point, verts() As Point) As Boolean
		  Dim wn As Integer    // the  winding number counter
		  
		  // loop through all edges of the polygon
		  For i As Integer= 0 To verts.Ubound- 1   // edge from V[i] to  V[i+1]
		    If verts(i).Y<= pnt.Y Then    // start y <= P.y
		      If verts(i+ 1).Y> pnt.Y Then   // an upward crossing
		        If IsLeft(verts(i), verts(i+ 1), pnt)> 0 Then   // P left of  edge
		          wn= wn+ 1  // have  a valid up intersect
		        End If
		      End If
		    ElseIf verts(i+ 1).Y<= pnt.Y Then // start y > P.y (no test needed)
		      If IsLeft(verts(i), verts(i+ 1), pnt)< 0 Then  // a downward crossing P right of  edge
		        wn= wn- 1    // have  a valid down intersect
		      End If
		    End If
		  Next
		  
		  If wn= 0 Then Return False Else Return True
		  
		  // Copyright 2000 softSurfer, 2012 Dan Sunday
		  // This code may be freely used and modified for any purpose
		  // providing that this copyright notice is included with it.
		  // SoftSurfer makes no warranty for this code, and cannot be held
		  // liable for any real or imagined damage resulting from its use.
		  // Users of this code must verify correctness for their application.
		  
		  // wn_PnPoly(): winding number test for a point in a polygon
		  //      Input:   P = a point,
		  //               V[] = vertex points of a polygon V[n+1] with V[n]=V[0]
		  //      Return:  wn = the winding number (=0 only when P is outside)
		  
		  // http://geomalgorithms.com/a03-_inclusion.html
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RectPattern(x As Double, y As Double, width As Double, height As Double, lengths() As Integer) As Group2D
		  'LBMSoft.Debug.Assert (lengths.Ubound> -1)
		  
		  Dim lengthsD() As Double
		  
		  For i As Integer= 0 To lengths.Ubound
		    lengthsD.Append lengths(i)
		  Next
		  
		  Return RectPattern(x, y, width, height, Patterns.Dashed, Nil, lengthsD)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RectPattern(x As Double, y As Double, width As Double, height As Double, pattern As Patterns = Patterns.Dashed, Optional style As CurveShape, Optional lengths() As Double) As Group2D
		  'LBMSoft.Debug.Assert (True)
		  
		  Dim shape As New Group2D
		  
		  Dim line1 As Group2D= LinePattern(x, y, x+ width, y, pattern, style, lengths)
		  shape.Append line1
		  
		  Dim line2 As Group2D= LinePattern(x+ width, y, x+ width, y+ height, pattern, style, lengths)
		  shape.Append line2
		  
		  Dim line3 As Group2D= LinePattern(x, y+ height, x+ width, y+ height, pattern, style, lengths)
		  shape.Append line3
		  
		  Dim line4 As Group2D= LinePattern(x, y, x, y+ height, pattern, style, lengths)
		  shape.Append line4
		  
		  Return shape
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RectPattern(posSize As Rect, lengths() As Integer) As Group2D
		  Return RectPattern(posSize.X, posSize.Y, posSize.Width, posSize.Height, lengths)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function RegularPoly(diameter As Integer, slides As Integer = 3) As FigureShape
		  'LBMSoft.Debug.Assert (slides>= 3)
		  
		  // sanity chk
		  If slides< 3 Then slides= 3
		  
		  Dim fx As New FigureShape
		  
		  Dim radius As Double= diameter/ 2
		  Dim stepAngle As Double= 360/ slides
		  Dim angle As Double
		  
		  Dim points() As Point
		  
		  While angle< (360)
		    points.Append DegreesToXY(angle, radius)
		    angle= angle+ stepAngle
		  Wend
		  
		  For j As Integer= 1 To slides- 1
		    fx.AddLine points(j- 1).X, points(j- 1).Y, points(j).X, points(j).Y
		  Next
		  
		  fx.Border = 80 // opaque border
		  fx.BorderColor = &c30303000 // dark border
		  fx.FillColor = &cE2E2E200 // light interior
		  
		  Return fx
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function Star(diameter As Integer, nPoints As Integer = 3, slope As Double = 0.2) As FigureShape
		  'LBMSoft.Debug.Assert (nPoints>= 3)
		  
		  // sanity chk
		  If nPoints< 3 Then nPoints= 3
		  
		  Dim fx As New FigureShape
		  
		  Dim radiuso As Integer= diameter/ 2
		  Dim radiusi As Integer= radiuso* slope
		  
		  Dim baseAngle As Double= kPI/ nPoints
		  Dim counter, oddeven As Integer
		  Dim i, r, yangle As Double
		  
		  Dim points() As Point
		  
		  While i<= (kPI* 2)
		    
		    If oddeven= 0 Then
		      r= radiuso
		      oddeven= 1
		      yangle= i
		    Else
		      r= radiusi
		      oddeven= 0
		      yangle= i
		    End If
		    
		    If counter= 0 Then
		    Else
		    End If
		    counter= counter+ 1
		    
		    points.Append New Point(r* Sin(i), r* Cos(yangle))
		    
		    i= i+ baseAngle
		  Wend
		  
		  For j As Integer= 1 To (nPoints* 2)- 1
		    fx.AddLine points(j- 1).X, points(j- 1).Y, points(j).X, points(j).Y
		  Next
		  
		  fx.Border = 80 // opaque border
		  fx.BorderColor = &c30303000 // dark border
		  fx.FillColor = &cE2E2E200 // light interior
		  
		  Return fx
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Shared Function StarPoints(diameter As Integer, nPoints As Integer = 3, slope As Double = 0.2, centerX As Integer = 0, centerY As Integer = 0) As Integer()
		  'LBMSoft.Debug.Assert (nPoints>= 3)
		  
		  // sanity chk
		  If nPoints< 3 Then nPoints= 3
		  
		  Dim radiuso As Integer= diameter/ 2
		  Dim radiusi As Integer= radiuso* slope
		  
		  Dim baseAngle As Double= kPI/ nPoints
		  Dim counter, oddeven As Integer
		  Dim i, r, yangle As Double
		  
		  Dim points() As Integer
		  points.Append 0
		  
		  While i<= (kPI* 2)
		    
		    If oddeven= 0 Then
		      r= radiuso
		      oddeven= 1
		      yangle= i
		    Else
		      r= radiusi
		      oddeven= 0
		      yangle= i
		    End If
		    
		    If counter= 0 Then
		    Else
		    End If
		    counter= counter+ 1
		    
		    points.Append centerX+ Round(r* Sin(i))
		    points.Append centerY+ Round(r* Cos(yangle))
		    
		    i= i+ baseAngle
		  Wend
		  
		  Return points
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ToDegrees(radians As Double) As Double
		  Return GetDegrees(radians)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function ToRadians(degrees As Double) As Double
		  Return GetRadians(degrees)
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

	#tag Method, Flags = &h0
		 Shared Function XYToDegrees(xy As Point) As Double
		  Dim radAngle As Double= Atan2(xy.Y, xy.X)
		  Dim degreeAngle As Double= radAngle* 180/ kPI
		  
		  Return 180- degreeAngle
		End Function
	#tag EndMethod


	#tag Note, Name = Readme
		
		Shape 2D utilities
		
		In the beginning I thought instantiate this class, but doesn't work, is better move this methods to a module.
	#tag EndNote


	#tag Property, Flags = &h21
		Private Shared mRandomize As Random
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mRandomize Is Nil Then mRandomize= New Random
			  
			  return mRandomize
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mRandomize= value
			End Set
		#tag EndSetter
		Shared Randomize As Random
	#tag EndComputedProperty


	#tag Constant, Name = kAphaColorEven, Type = Color, Dynamic = False, Default = \"&cE6E6E600", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAphaColorOdd, Type = Color, Dynamic = False, Default = \"&cC0C0C000", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kAphaColorSize, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kPI, Type = Double, Dynamic = False, Default = \"3.1415926535897932384626433832795", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = Version, Type = String, Dynamic = False, Default = \"0.0.191123", Scope = Public
	#tag EndConstant


	#tag Enum, Name = Patterns, Flags = &h0
		Solid
		  Dashed
		Dotted
	#tag EndEnum


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
