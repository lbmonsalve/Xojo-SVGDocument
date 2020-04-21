#tag Module
Protected Module SVGExtendsLBM
	#tag Method, Flags = &h0
		Function Circle(Extends nodeXML As XMLNode, cx As Double, cy As Double, r As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("circle"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("circle"))
		  End If
		  
		  node.SetAttribute "cx", NumberToString(cx)
		  node.SetAttribute "cy", NumberToString(cy)
		  node.SetAttribute "r", NumberToString(r)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Circle(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("circle"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("circle"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClassAttr(Extends node As XmlElement, value As String)
		  node.SetAttribute("class", value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ClipPath(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("clipPath"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("clipPath"))
		  End If
		  
		  // TODO: chk id
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ClipPath(Extends nodeXML As XMLNode, id As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("clipPath"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("clipPath"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Comment(Extends nodeXML As XMLNode, value As String) As XmlComment
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateComment(value))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateComment(value))
		  End If
		  
		  Return XmlComment(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Defs(Extends nodeXML As XMLNode) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("defs"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("defs"))
		  End If
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Desc(Extends nodeXML As XMLNode, value As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("desc"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("desc"))
		  End If
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateTextNode(value))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ellipse(Extends nodeXML As XMLNode, cx As Double, cy As Double, rx As Double, ry As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("ellipse"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("ellipse"))
		  End If
		  
		  node.SetAttribute "cx", NumberToString(cx)
		  node.SetAttribute "cy", NumberToString(cy)
		  node.SetAttribute "rx", NumberToString(rx)
		  node.SetAttribute "ry", NumberToString(ry)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Ellipse(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("ellipse"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("ellipse"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Fill(Extends node As XmlElement, value As String)
		  node.SetAttribute("fill", value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Filter(Extends nodeXML As XMLNode, id As String, x As Double, y As Double, width As Double, height As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("filter"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("filter"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  node.SetAttribute "width", NumberToString(width)
		  node.SetAttribute "height", NumberToString(height)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FilterGaussianBlur(Extends nodeXML As XMLNode, stdDeviation As Double, inFilter As String = "SourceGraphic") As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("feGaussianBlur"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("feGaussianBlur"))
		  End If
		  
		  node.SetAttribute "in", inFilter
		  node.SetAttribute "stdDeviation", NumberToString(stdDeviation)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FilterMerge(Extends nodeXML As XMLNode) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("feMerge"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("feMerge"))
		  End If
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FilterMergeMode(Extends nodeXML As XMLNode, inFilter As String = "SourceGraphic") As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("feMergeNode"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("feMergeNode"))
		  End If
		  
		  node.SetAttribute "in", inFilter
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FilterOffset(Extends nodeXML As XMLNode, dx As Double, dy As Double, result As String, inFilter As String = "SourceGraphic") As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("feOffset"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("feOffset"))
		  End If
		  
		  node.SetAttribute "in", inFilter
		  node.SetAttribute "dx", NumberToString(dx)
		  node.SetAttribute "dy", NumberToString(dy)
		  node.SetAttribute "result", result
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ForeignObject(Extends nodeXML As XMLNode, x As Double, y As Double, width As Double, height As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("foreignObject"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("foreignObject"))
		  End If
		  
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  node.SetAttribute "width", NumberToString(width)
		  node.SetAttribute "height", NumberToString(height)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetSubAttribute(Extends nodeXML As XmlElement, name As String, subName As String) As String
		  Dim attrib As String= nodeXML.GetAttribute(name)
		  
		  If attrib= "" Then Return ""
		  
		  If name.Lowercase= "style" Then
		    attrib= attrib.Trim
		    
		    Dim attribs() As String= Split(attrib, ";")
		    For i As Integer= 0 To attribs.Ubound
		      Dim attr As String= attribs(i)
		      Dim attrName As String= attr.Left(attr.InStr(":")- 1).Trim
		      Dim attrValue As String= attr.Mid(attr.InStr(":")+ 1).Trim
		      If attrName.Lowercase= subName.Lowercase Then Return attrValue
		    Next
		  ElseIf name.Lowercase= "transform" Then
		    Dim rg As New RegEx
		    Dim rgm As RegExMatch
		    
		    // search
		    rg.SearchPattern= "([A-za-z]+)(\(.([^\(]+)\))"
		    rgm= rg.Search(attrib)
		    
		    While rgm<> Nil
		      Dim attr As String= rgm.SubExpressionString(0)
		      Dim attrName As String= attr.Left(attr.InStr("(")- 1).Trim
		      Dim attrValue As String= attr.Mid(attr.InStr("(")).ReplaceAll("(", "").ReplaceAll(")", "").Trim
		      
		      If attrName.Lowercase= subName.Lowercase Then Return attrValue
		      
		      rgm= rg.Search
		    Wend
		  End If
		  
		  Return ""
		  
		Exception err as RegExException
		  SVGDocument.DebugLog CurrentMethodName+ " RegEx error: "+ err.Message
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GradientLinear(Extends nodeXML As XMLNode, id As String, x1 As String, y1 As String, x2 As String, y2 As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("linearGradient"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("linearGradient"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "x1", x1
		  node.SetAttribute "y1", y1
		  node.SetAttribute "x2", x2
		  node.SetAttribute "y2", y2
		  node.SetAttribute "spreadMethod", "pad"
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GradientRadial(Extends nodeXML As XMLNode, id As String, fx As String, fy As String, r As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("radialGradient"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("radialGradient"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "fx", fx
		  node.SetAttribute "fy", fy
		  node.SetAttribute "r", r
		  node.SetAttribute "spreadMethod", "pad"
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GradientStop(Extends nodeXML As XMLNode, offset As String, stopColor As String, stopOpacity As String = "1") As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("stop"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("stop"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "offset", offset
		  node.SetAttribute "stop-color", stopColor
		  node.SetAttribute "stop-opacity", stopOpacity
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Group(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("g"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("g"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ID(Extends node As XmlElement, value As String)
		  // TODO: chk for id
		  
		  node.SetAttribute("id", value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Image(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("image"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("image"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Image(Extends nodeXML As XMLNode, xLinkHref As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("image"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("image"))
		  End If
		  
		  node.SetAttribute "xlink:href", xLinkHref
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Line(Extends nodeXML As XMLNode, x1 As Double, y1 As Double, x2 As Double, y2 As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("line"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("line"))
		  End If
		  
		  node.SetAttribute "x1", NumberToString(x1)
		  node.SetAttribute "y1", NumberToString(y1)
		  node.SetAttribute "x2", NumberToString(x2)
		  node.SetAttribute "y2", NumberToString(y2)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Line(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("line"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("line"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Link(Extends nodeXML As XMLNode, xLinkHref As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("a"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("a"))
		  End If
		  
		  node.SetAttribute "xlink:href", xLinkHref
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Marker(Extends nodeXML As XMLNode, id As String, width As Double, height As Double, refX As Double = 0, refY As Double = 0) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("marker"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("marker"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "refX", NumberToString(refX)
		  node.SetAttribute "refY", NumberToString(refY)
		  node.SetAttribute "markerWidth", NumberToString(width)
		  node.SetAttribute "markerHeight", NumberToString(height)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Mask(Extends nodeXML As XMLNode, id As String, x As Double, y As Double, width As Double, height As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("mask"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("mask"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  node.SetAttribute "width", NumberToString(width)
		  node.SetAttribute "height", NumberToString(height)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NumberToString(number As Double, frmt As String = "-#############0.0#######") As String
		  Dim str As String= Str(number, frmt)
		  If str.Right(2)= ".0" Then str= str.Mid(1, str.Len- 2)
		  
		  Return str
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenAsSVG(Extends f As FolderItem) As SVGDocument
		  If f= Nil Then Return Nil
		  
		  Return New SVGDocument(f)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenSVG(Extends f As FolderItem) As Group2D
		  If f= Nil Then Return Nil
		  
		  Return f.OpenAsSVG.ToGroup2D
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenSVG(Extends f As FolderItem) As Picture
		  If f= Nil Then Return Nil
		  
		  Return f.OpenAsSVG.ToPicture
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function OpenSVG(Extends f As FolderItem, width As Integer, height As Integer) As Picture
		  If f= Nil Then Return Nil
		  
		  Return f.OpenAsSVG.ToPicture(width, height)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ParseUnits(Extends str As String) As Double
		  Dim ret As Double
		  
		  If str.InStr("em")> 0 Then
		    ret= str.Val* 16 // TODO: fix this! -default font size-
		  ElseIf str.InStr("ex")> 0 Then
		    ret= str.Val* 10 // TODO: fix this! -height of the character x-
		  ElseIf str.InStr("px")> 0 Then
		    ret= str.Val
		  ElseIf str.InStr("pt")> 0 Then
		    ret= (str.Val* 72)/ 6
		  ElseIf str.InStr("pc")> 0 Then
		    ret= (str.Val* kPixelsPerInch)/ 6
		  ElseIf str.InStr("cm")> 0 Then
		    ret= str.Val* kPixelsPerInch
		  ElseIf str.InStr("mm")> 0 Then
		    ret= (str.Val* kPixelsPerInch)/ 25.4
		  ElseIf str.InStr("in")> 0 Then
		    ret= (str.Val* kPixelsPerInch)
		  Else
		    ret= str.Val
		  End If
		  
		  Return ret
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Path(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("path"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("path"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Path(Extends nodeXML As XMLNode, draw As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("path"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("path"))
		  End If
		  
		  node.SetAttribute "d", draw
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pattern(Extends nodeXML As XMLNode, id As String, x As Double, y As Double, width As Double, height As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("pattern"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("pattern"))
		  End If
		  
		  // TODO: chk id
		  
		  node.SetAttribute "id", id
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  node.SetAttribute "width", NumberToString(width)
		  node.SetAttribute "height", NumberToString(height)
		  node.SetAttribute "patternUnits", "userSpaceOnUse"
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Polygon(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("polygon"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("polygon"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Polygon(Extends nodeXML As XMLNode, points As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("polygon"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("polygon"))
		  End If
		  
		  node.SetAttribute "points", points
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Polyline(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("polyline"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("polyline"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Polyline(Extends nodeXML As XMLNode, points As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("polyline"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("polyline"))
		  End If
		  
		  node.SetAttribute "points", points
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Rect(Extends nodeXML As XMLNode, x As Double, y As Double, width As Double, height As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("rect"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("rect"))
		  End If
		  
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  node.SetAttribute "width", NumberToString(width)
		  node.SetAttribute "height", NumberToString(height)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Rect(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("rect"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("rect"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Script(Extends nodeXML As XMLNode, xLinkHref As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("script"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("script"))
		  End If
		  
		  node.SetAttribute("type", "text/javascript")
		  node.SetAttribute("xlink:href", xLinkHref)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ScriptCDATA(Extends nodeXML As XMLNode, script As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("script"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("script"))
		  End If
		  
		  node.SetAttribute("type", "text/javascript")
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateCDATASection(script))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Style(Extends node As XmlElement, value As String)
		  node.SetAttribute("style", value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Style(Extends node As XmlNode, value As String)
		  node.SetAttribute("style", value)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StyleCDATA(Extends nodeXML As XMLNode, value As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("style"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("style"))
		  End If
		  
		  node.SetAttribute("type", "text/css")
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateCDATASection(value))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Svg(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("svg"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("svg"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Symbol(Extends nodeXML As XMLNode) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("symbol"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("symbol"))
		  End If
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Text(Extends nodeXML As XMLNode, value As String, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("text"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("text"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateTextNode(value))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextPath(Extends nodeXML As XMLNode, xLinkHref As String, value As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("textPath"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("textPath"))
		  End If
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateTextNode(value))
		  #pragma Unused nodeChild
		  
		  XmlElement(node).SetAttribute "xlink:href", "#"+ xLinkHref
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextRef(Extends nodeXML As XMLNode, xLinkHref As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("textPath"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("textPath"))
		  End If
		  
		  XmlElement(node).SetAttribute "xlink:href", "#"+ xLinkHref
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextSpan(Extends nodeXML As XMLNode, value As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("tspan"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("tspan"))
		  End If
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateTextNode(value))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TextValue(Extends node As XmlElement) As String
		  If node.ChildCount> 0 Then
		    Dim child As XmlNode= node.FirstChild
		    Return child.Value
		  End If
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TextValue(Extends node As XmlElement, value As String)
		  If node.ChildCount> 0 Then
		    Dim child As XmlNode= node.FirstChild
		    child.Value= value
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Title(Extends nodeXML As XMLNode, value As String) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("title"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("title"))
		  End If
		  
		  Dim nodeChild As XmlNode= node.AppendChild(xml.CreateTextNode(value))
		  #pragma Unused nodeChild
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Use(Extends nodeXML As XMLNode, ParamArray attrib As Pair) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("use"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("use"))
		  End If
		  
		  For Each attr As Pair In attrib
		    node.SetAttribute attr.Left.StringValue.Lowercase, attr.Right.StringValue
		  Next
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Use(Extends nodeXML As XMLNode, xLinkHref As String, x As Double, y As Double) As XMLElement
		  Dim xml As XmlDocument
		  Dim node As XmlNode
		  
		  If nodeXML.OwnerDocument<> Nil Then
		    xml= nodeXML.OwnerDocument
		    node= nodeXML.AppendChild(xml.CreateElement("use"))
		  ElseIf nodeXML.FirstChild.OwnerDocument<> Nil Then
		    xml= nodeXML.FirstChild.OwnerDocument
		    node= xml.FirstChild.AppendChild(xml.CreateElement("use"))
		  End If
		  
		  node.SetAttribute "xlink:href", xLinkHref
		  node.SetAttribute "x", NumberToString(x)
		  node.SetAttribute "y", NumberToString(y)
		  
		  Return XmlElement(node)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub WidthHeight(Extends node As XmlElement, width As String, height As String)
		  node.SetAttribute("widht", width)
		  node.SetAttribute("height", height)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub XY(Extends node As XmlElement, x As String, y As String)
		  node.SetAttribute("x", x)
		  node.SetAttribute("y", y)
		End Sub
	#tag EndMethod


	#tag Constant, Name = kPixelsPerInch, Type = Double, Dynamic = False, Default = \"96", Scope = Protected
	#tag EndConstant


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
