#tag Window
Begin ContainerControl CanvasPanel
   AcceptFocus     =   ""
   AcceptTabs      =   True
   AutoDeactivate  =   True
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   Enabled         =   True
   EraseBackground =   False
   HasBackColor    =   False
   Height          =   349
   HelpTag         =   ""
   InitialParent   =   ""
   Left            =   32
   LockBottom      =   True
   LockLeft        =   True
   LockRight       =   True
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Top             =   32
   UseFocusRing    =   ""
   Visible         =   True
   Width           =   300
   Begin Canvas Canvas1
      AcceptFocus     =   ""
      AcceptTabs      =   ""
      AutoDeactivate  =   True
      Backdrop        =   ""
      DoubleBuffer    =   True
      Enabled         =   True
      EraseBackground =   False
      Height          =   300
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   0
      UseFocusRing    =   True
      Visible         =   True
      Width           =   260
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Open..."
      Default         =   ""
      Enabled         =   True
      Height          =   30
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   310
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin TextField TextField1
      AcceptTabs      =   ""
      Alignment       =   0
      AutoDeactivate  =   True
      AutomaticallyCheckSpelling=   False
      BackColor       =   &hFFFFFF
      Bold            =   ""
      Border          =   True
      CueText         =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Format          =   ""
      Height          =   30
      HelpTag         =   ""
      Index           =   -2147483648
      Italic          =   ""
      Left            =   92
      LimitText       =   0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Mask            =   ""
      Password        =   ""
      ReadOnly        =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   310
      Underline       =   ""
      UseFocusRing    =   True
      Visible         =   True
      Width           =   208
   End
   Begin Slider Slider1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   260
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   270
      LineStep        =   10
      LiveScroll      =   True
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      Maximum         =   200
      Minimum         =   10
      PageStep        =   25
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      TickStyle       =   0
      Top             =   0
      Value           =   100
      Visible         =   True
      Width           =   30
   End
   Begin PushButton PushButton2
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Fit"
      Default         =   ""
      Enabled         =   True
      Height          =   30
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   270
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   16
      TextUnit        =   0
      Top             =   270
      Underline       =   ""
      Visible         =   True
      Width           =   30
   End
End
#tag EndWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub DoFit()
		  If mSvgGroup2d Is Nil Then Return
		  
		  mFit= Not mFit
		  
		  If mFit Then
		    PushButton2.Caption= "Ori"
		    Canvas1.Invalidate
		  Else
		    PushButton2.Caption= "Fit"
		    Slider1.Value= 100
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OnPaint(g As Graphics)
		  #pragma BackgroundTasks False
		  
		  If mBuffer Is Nil Then
		    mBuffer= New Picture(g.Width, g.Height, 32)
		  ElseIf mBuffer.Width<> g.Width Or mBuffer.Height<> g.Height Then
		    mBuffer= New Picture(g.Width, g.Height, 32)
		  End If
		  
		  Static bkg As PixmapShape
		  If bkg= Nil Then
		    bkg= Shape2D.ChessBoard(g.Width, g.Height, 15)
		  ElseIf bkg.Width<> g.Width Or bkg.Height<> g.Height Then
		    bkg= Shape2D.ChessBoard(g.Width, g.Height, 15)
		  End If
		  
		  mBuffer.Graphics.DrawObject bkg, g.Width/ 2, g.Height/ 2
		  
		  If mSvgGroup2d Is Nil Then
		    g.DrawPicture mBuffer, 0, 0
		    Return
		  End If
		  
		  Dim deltaX, deltaY As Integer
		  
		  If mFit Then
		    mSvgGroup2d.Scale= 1.0
		    Dim size As Size= mSvgGroup2d.GetSize
		    Dim ratio As Double = Min(g.Height/ size.Height, g.Width/ size.Width)
		    mSvgGroup2d.Scale= ratio
		    deltaX= Floor(size.Width* ratio/ 2)
		    deltaY= Floor(size.Height* ratio/ 2)
		    
		    mBuffer.Graphics.DrawObject mSvgGroup2d, (g.Width/ 2)- deltaX, (g.Height/ 2)- deltaY
		    
		    mUpdateScale= False
		    Slider1.Value= mSvgGroup2d.Scale* 100
		    mUpdateScale= True
		  Else
		    'Dim size As Size= mSvgGroup2d.GetSize
		    'deltaX= (size.Width/ 2)
		    'deltaY= (size.Height/ 2)
		    '
		    'g.DrawObject mSvgGroup2d, (g.Width/ 2)- deltaX, (g.Height/ 2)- deltaY
		    
		    mBuffer.Graphics.DrawObject mSvgGroup2d, 0, 0
		  End If
		  
		  g.DrawPicture mBuffer, 0, 0
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OnScale()
		  If (mSvgGroup2d Is Nil) Or Not mUpdateScale Then Return
		  
		  mSvgGroup2d.Scale= Slider1.Value/ 100
		  
		  If mFit Then
		    mFit= False
		    PushButton2.Caption= "Fit"
		  End If
		  
		  Canvas1.Invalidate
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OpenFile()
		  Dim svgType As New FileType
		  svgType.Name = "image/svg+xml"
		  svgType.MacType = "svg "
		  svgType.Extensions = "svg;svgz"
		  
		  Dim anyType As New FileType
		  anyType.Name = "All"
		  anyType.MacType = "????"
		  anyType.Extensions = ""
		  
		  Dim f As FolderItem= GetOpenFolderItem(svgType+ anyType)
		  If f Is Nil Then Return
		  
		  // init slider
		  mSvgGroup2d= Nil
		  Slider1.Value= 100
		  
		  TextField1.Text= f.Name
		  
		  Dim svg As New SVGDocument(f)
		  mSvgGroup2d= svg.ToGroup2D
		  
		  Canvas1.Invalidate
		  
		  'svg.ToPicture.Save(SpecialFolder.Documents.Child("SVGDocument.png"), Picture.SaveAsPNG)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private mBuffer As Picture
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mFit As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mSvgGroup2d As Group2D
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mUpdateScale As Boolean = True
	#tag EndProperty


#tag EndWindowCode

#tag Events Canvas1
	#tag Event
		Sub Paint(g As Graphics)
		  OnPaint g
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  OpenFile
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events Slider1
	#tag Event
		Sub ValueChanged()
		  OnScale
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton2
	#tag Event
		Sub Action()
		  DoFit
		End Sub
	#tag EndEvent
#tag EndEvents
