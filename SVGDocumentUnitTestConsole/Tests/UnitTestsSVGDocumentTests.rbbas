#tag Class
Protected Class UnitTestsSVGDocumentTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  mSvg= CreateDocument
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub ConstructorTest()
		  Dim svg As New SVGDocument
		  
		  If svg Is Nil Then
		    Assert.Fail("svg Is Nil")
		    Return
		  End If
		  
		  Dim root As XmlElement= svg.Root
		  
		  If root Is Nil Then
		    Assert.Fail("root Is Nil")
		    Return
		  End If
		  
		  Assert.AreSame(SVGDocument.kXmlTagSvg, root.Name)
		  
		  Assert.AreSame(SVGDocument.kXmlAttrXmlnsValue, _
		  root.GetAttributeNode(SVGDocument.kXmlAttrXmlnsTag).Value)
		  Assert.AreSame(SVGDocument.kXmlAttrXmlnsXlinkValue, _
		  root.GetAttributeNode(SVGDocument.kXmlAttrXmlnsXlinkTag).Value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateDocument() As SVGDocument
		  Dim svg As New SVGDocument
		  svg.Root.SetAttribute("width", "600")
		  svg.Root.SetAttribute("height", "500")
		  'svg.Root.RemoveAttribute("width")
		  'svg.Root.RemoveAttribute("height")
		  
		  svg.Root.SetAttribute("viewBox", "0 0 600 500")
		  'svg.Root.SetAttribute("preserveAspectRatio", "xMaxYMax meet")
		  
		  'svg.Root.SetAttribute("width", "100%")
		  'svg.Root.SetAttribute("height", "100%")
		  'svg.Root.SetAttribute("viewBox", "0 0 500 500")
		  
		  Dim def1 As XmlElement= svg.Defs
		  
		  Dim desc1 As XmlElement= svg.Desc("sample desc")
		  #pragma Unused desc1
		  
		  Dim title1 As XmlElement= svg.Title("sample title")
		  #pragma Unused title1
		  Dim text1 As XmlElement= svg.Text("sample Text", "x": "20.22", "y": "40.25", _
		  "style": "fill:none;stroke:#000000; font-size: 48px;")
		  #pragma Unused text1
		  
		  Dim rect1 As XmlElement= svg.Rect(10, 60, 100, 100)
		  rect1.Style("stroke:#006600; fill: #00cc00")
		  'rect1.Fill("#f06")
		  
		  Dim comm As XmlComment= svg.Comment("test comment")
		  #pragma Unused comm
		  
		  Dim grp1 As XmlElement= svg.Group
		  Dim link1 As XmlElement= grp1.Link("/svg/index.html")
		  Dim text2 As XmlElement= link1.Text("sample link1 text2")
		  text2.SetAttribute("x", "300")
		  text2.SetAttribute("y", "40")
		  Dim circ1 As XmlElement= grp1.Circle(150, 150, 50)
		  circ1.Style("stroke:#006600; stroke-width: 3; stroke-dasharray: 10 5; fill:#00cc00;")
		  Dim elli1 As XmlElement= grp1.Ellipse(150, 150, 75, 25)
		  elli1.Style("stroke: #000066; fill: #0000cc; fill-opacity: 0.5")
		  Dim lin1 As XmlElement= grp1.Line(10, 10, 200, 200)
		  lin1.Style("stroke:#006600;")
		  
		  Dim svg1 As XmlElement= svg.Svg
		  svg1.SetAttribute("x", "200")
		  svg1.SetAttribute("y", "100")
		  Dim polyline1 As XmlElement= svg1.Polyline("10,2  60,2  35,52  10,2")
		  polyline1.Style("stroke:#006600; fill: #33cc33;")
		  Dim svg2 As XmlElement= grp1.Svg
		  svg2.SetAttribute("x", "170")
		  svg2.SetAttribute("y", "170")
		  Dim polygon1 As XmlElement= svg2.Polygon("50,5   100,5  125,30  125,80 100,105 50,105  25,80  25, 30")
		  polygon1.Style("stroke:#660000; fill:#cc3333; stroke-width: 3;")
		  
		  Dim svg3 As XmlElement= svg.Svg("x":"300", "y":"100")
		  Dim path1 As XmlElement= svg3.Path("M40,20  A30,30 0 0,0 70,70")
		  path1.Style("stroke: #cccc00; stroke-width:2; fill:none;")
		  Dim path2 As XmlElement= svg3.Path("M40,20  A30,30 0 1,0 70,70")
		  path2.Style("stroke: #ff0000; stroke-width:2; fill:none;")
		  Dim path3 As XmlElement= svg3.Path("M40,20  A30,30 0 1,1 70,70")
		  path3.Style("stroke: #00ff00; stroke-width:2; fill:none;")
		  Dim path4 As XmlElement= svg3.Path("M40,20  A30,30 0 0,1 70,70")
		  path4.Style("stroke: #0000ff; stroke-width:2; fill:none;")
		  
		  Dim img1 As XmlElement= svg.Image("http://svgjs.com/assets/images/logo-svg-js-01d-128.png")
		  img1.XY("50", "200")
		  img1.WidthHeight("128", "128")
		  img1.SetAttribute("transform", " translate(60,-40) rotate(45, 50, 200) scale(0.5)") //  skewX(10)
		  
		  Dim g1d1 As XmlElement= def1.Group
		  g1d1.SetAttribute("id", "shape")
		  Dim rect1g1d1 As XmlElement= g1d1.Rect(50, 50, 50, 50)
		  rect1g1d1.Fill("blue")
		  Dim circ1g1d1 As XmlElement= g1d1.Circle(50, 50, 50)
		  circ1g1d1.Fill("deepskyblue")
		  Dim use1 As XmlElement= svg.Use("#shape", 10, 300)
		  #pragma Unused  use1
		  
		  Dim svg4 As XmlElement= svg.Svg
		  svg4.SetAttribute("x", "120")
		  svg4.SetAttribute("y", "300")
		  
		  Dim patt1 As XmlElement= def1.Pattern("pattern1", 10, 10, 20, 20)
		  Dim circ1p1 As XmlElement= patt1.Circle(10, 10, 10)
		  circ1p1.Style("stroke: none; fill: #0000ff")
		  Dim rect2g1d1 As XmlElement= svg4.Rect(2, 2, 100, 100)
		  rect2g1d1.Style("stroke: #000000; fill: url(#pattern1);")
		  
		  Dim patt2 As XmlElement= def1.Pattern("pattern2", 3, 3, 9, 9)
		  Dim rect1p2 As XmlElement= patt2.Rect(0, 0, 6, 6)
		  rect1p2.Style("stroke: none; fill: #ff0000")
		  Dim patt3 As XmlElement= def1.Pattern("pattern3", 12, 12, 25, 25)
		  Dim circ1p3 As XmlElement= patt3.Circle(10, 10, 10)
		  circ1p3.Style("stroke: #0000ff; fill: url(#pattern2)")
		  
		  Dim rect3g1d1 As XmlElement= svg4.Rect(110, 2, 100, 100)
		  rect3g1d1.Style("stroke: #000000; fill: url(#pattern3);")
		  
		  Dim grd1 As XmlElement= def1.GradientLinear("LinearGradient1", "0%", "0%", "0%", "100%")
		  grd1.SetAttribute("gradientTransform", "rotate(45)")
		  Dim stp1 As XmlElement= grd1.GradientStop("0%", "#00cc00")
		  #pragma Unused stp1
		  
		  Dim stp2 As XmlElement= grd1.GradientStop("100%", "#006600")
		  #pragma Unused stp2
		  
		  Dim rect4g1d1 As XmlElement= svg4.Rect(220, 2, 100, 100)
		  rect4g1d1.Style("fill:url(#LinearGradient1); stroke: #005000; stroke-width: 3;")
		  
		  Dim svg5 As XmlElement= svg.Svg
		  svg5.SetAttribute("x", "320")
		  svg5.SetAttribute("y", "190")
		  
		  Dim grd2 As XmlElement= def1.GradientRadial("RadialGradient4", "50%", "50%", "65%")
		  Dim stp3 As XmlElement= grd2.GradientStop("0%", "#00ee00")
		  #pragma Unused stp3
		  
		  Dim stp4 As XmlElement= grd2.GradientStop("100%", "#006600")
		  #pragma Unused stp4
		  
		  Dim rect5g1d1 As XmlElement= svg5.Rect(2, 2, 100, 100)
		  rect5g1d1.Style("fill:url(#RadialGradient4); stroke: #005000; stroke-width: 3;")
		  
		  Dim clip1 As XmlElement= def1.ClipPath("clipPath1")
		  Dim text1c1 As XmlElement= clip1.Text("ClipPath example", "x":"10", "y":"20", "style":"font-size: 20px")
		  #pragma Unused text1c1
		  
		  Dim grp2 As XmlElement= svg.Group
		  grp2.Style("clip-path: url(#clipPath1)")
		  Dim rect1g2 As XmlElement= grp2.Rect(0, 0, 190, 90)
		  rect1g2.Style("stroke: none; fill:#00ff00")
		  Dim circ1g2 As XmlElement= grp2.Circle(20, 20, 20)
		  circ1g2.Style("stroke: none; fill: #ff0000")
		  
		  Dim grd3 As XmlElement= def1.GradientLinear("maskGradient1", "0%", "0%", "100%", "0%")
		  Dim stp5 As XmlElement= grd3.GradientStop("0%", "#ffffff")
		  #pragma Unused stp5
		  
		  Dim stp6 As XmlElement= grd3.GradientStop("100%", "#000000")
		  #pragma Unused stp6
		  
		  Dim mask1 As XmlElement= def1.Mask("mask1", 0, 0, 200, 100)
		  Dim rect1m1 As XmlElement= mask1.Rect(0, 0, 200, 100)
		  rect1m1.Style("stroke:none; fill: url(#maskGradient1)")
		  
		  Dim svg6 As XmlElement= svg.Svg("x":"0", "y":"190")
		  
		  Dim text1s6 As XmlElement= svg6.Text("This text is under the rectangle")
		  text1s6.XY("10", "55")
		  text1s6.Style("stroke: none; fill: #000000; font-size: 20px")
		  Dim rect1s6 As XmlElement= svg6.Rect(1, 1, 200, 100)
		  rect1s6.Style("stroke: none; fill: #0000ff; mask: url(#mask1)")
		  
		  Dim filt1 As XmlElement= def1.Filter("blurFilter4", -20, -20, 200, 200)
		  Dim filt1blur As XmlElement= filt1.FilterGaussianBlur(12)
		  #pragma Unused filt1blur
		  
		  Dim svg7 As XmlElement= svg.Svg
		  svg7.SetAttribute("x", "400")
		  svg7.SetAttribute("y", "50")
		  
		  Dim rect1s7 As XmlElement= svg7.Rect(20, 20, 90, 90)
		  rect1s7.Style("stroke: none; fill: #00ff00; filter: url(#blurFilter4);")
		  
		  Dim script1 As XmlElement= svg.Script("svg.min.js")
		  #pragma Unused script1
		  
		  Dim script2 As XmlElement= svg.ScriptCDATA(kTextScriptSVG1)
		  #pragma Unused script2
		  
		  Dim circ1i1 As XmlElement= svg.Circle(50, 50, 10)
		  circ1i1.ID("circle1")
		  Dim foreign1 As XmlElement= svg.ForeignObject(70, 70, 300, 300)
		  Dim div1 As XmlNode= foreign1.AppendChild(svg.CreateElement("div"))
		  div1.SetAttribute("xmlns", "http://www.w3.org/1999/xhtml")
		  Dim btn1 As XmlNode= div1.AppendChild(svg.CreateElement("input"))
		  btn1.SetAttribute("type", "button")
		  btn1.SetAttribute("value", "Start Animation")
		  btn1.SetAttribute("onclick", "startAnimation();")
		  Dim btn2 As XmlNode= div1.AppendChild(svg.CreateElement("input"))
		  btn2.SetAttribute("type", "button")
		  btn2.SetAttribute("value", "Stop Animation")
		  btn2.SetAttribute("onclick", "stopAnimation();")
		  
		  Dim text3 As XmlElement= svg.Text("")
		  text3.XY("130", "60")
		  Dim text3s1 As XmlElement= text3.TextSpan("tspan line 1")
		  #pragma Unused text3s1
		  
		  Dim text3s2 As XmlElement= text3.TextSpan("tspan line 2")
		  text3s2.SetAttribute("dy", "10")
		  
		  Dim path5t1 As XmlElement= def1.Path("M10,80 a1,1 0 0,0 100,0")
		  path5t1.ID("myTextPath")
		  Dim text4 As XmlElement= svg.Text("")
		  text4.Style("stroke: chocolate")
		  Dim text5 As XmlElement= text4.TextPath("myTextPath", "Text along a curved path...")
		  #pragma Unused text5
		  
		  Dim mark1 As XmlElement= def1.Marker("markerCircle", 12, 12, 5, 5)
		  Dim circ1m1 As XmlElement= mark1.Circle(5, 5, 5)
		  circ1m1.Style("stroke: none; fill:limegreen")
		  
		  Dim mark2 As XmlElement= def1.Marker("markerArrow", 13, 13, 2, 6)
		  mark2.SetAttribute("orient", "auto")
		  Dim path1m1 As XmlElement= mark2.Path("M2,2 L2,11 L10,6 L2,2")
		  path1m1.Style("fill: mediumturquoise")
		  
		  Dim path5 As XmlElement= svg.Path("M245,10 L295,10 L295,60")
		  path5.Style("stroke: #6666ff; stroke-width: 1px; fill: none;marker-start: url(#markerCircle);marker-end: url(#markerArrow);")
		  
		  Dim style1 As XmlElement= svg.StyleCDATA(".myCircle { fill:plum; stroke:darkslateblue; stroke-width:3 }")
		  #pragma Unused style1
		  
		  Dim circ2 As XmlElement= svg.Circle(500, 240, 50)
		  circ2.ClassAttr("myCircle")
		  
		  'Dim rect2 As XmlElement= svg.Rect("x": "10", "y":"10", "width": "4cm", "height": "4cm", "style": "stroke:blue; fill:azure;")
		  
		  Return svg
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateDocumentTest()
		  Dim svg As SVGDocument= mSvg
		  
		  If svg Is Nil Then
		    Assert.Fail("svg Is Nil")
		  Else
		    Assert.Pass("Pass!")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToGroup2DTest()
		  Dim grp1 As Group2D= mSvg.ToGroup2D
		  
		  If grp1 Is Nil Then
		    Assert.Fail("grp1 Is Nil")
		    Return
		  End If
		  
		  Assert.AreEqual(17, grp1.Count, "grp1.Count")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToPictureTest()
		  Dim pic1 As Picture= mSvg.ToPicture
		  
		  If pic1 Is Nil Then
		    Assert.Fail("pic1 Is Nil")
		    Return
		  End If
		  
		  Assert.AreEqual(600, pic1.Width, "pic1.Width")
		  Assert.AreEqual(500, pic1.Height, "pic1.Height")
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mSvg As SVGDocument
	#tag EndProperty


	#tag Constant, Name = kTextScriptSVG1, Type = String, Dynamic = False, Default = \"var timerFunction \x3D null;\r\r    function startAnimation() {\r        if(timerFunction \x3D\x3D null) {\r            timerFunction \x3D setInterval(animate\x2C 20);\r        }\r    }\r\r    function stopAnimation() {\r        if(timerFunction !\x3D null){\r            clearInterval(timerFunction);\r            timerFunction \x3D null;\r        }\r    }\r\r    function animate() {\r        var circle \x3D document.getElementById(\"circle1\");\r        var x \x3D circle.getAttribute(\"cx\");\r        var newX \x3D 2 + parseInt(x);\r        if(newX > 500) {\r            newX \x3D 20;\r        }\r        circle.setAttribute(\"cx\"\x2C newX);\r    }", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Group="Behavior"
			Type="Double"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
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
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Group="Behavior"
			Type="Boolean"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Group="Behavior"
			Type="Integer"
			InheritedFrom="TestGroup"
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
