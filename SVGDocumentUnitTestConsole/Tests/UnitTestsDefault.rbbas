#tag Class
Protected Class UnitTestsDefault
Inherits TestGroup
	#tag Event
		Sub Setup()
		  Prop2 = Prop2 + 1
		  
		End Sub
	#tag EndEvent

	#tag Event
		Sub TearDown()
		  Prop2 = Prop2 - 1
		  
		  If AsyncTestTimer IsA Object Then
		    AsyncTestTimer.Mode = Timer.ModeOff
		    RemoveHandler AsyncTestTimer.Action, WeakAddressOf AsyncTestTimer_Action
		    AsyncTestTimer = Nil
		  End If
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(err As RuntimeException, methodName As String) As Boolean
		  #pragma unused err
		  
		  Const kMethodName = "UnhandledException"
		  
		  If methodName.Len >= kMethodName.Len And methodName.Left(kMethodName.Len) = kMethodName Then
		    Assert.Pass("Exception was handled")
		    Return True
		  End If
		End Function
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub AreDifferentObjectTest()
		  Dim d1 As New Date
		  Dim d2 As New Date(2001, 1, 1)
		  
		  Assert.AreDifferent(d1, d2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreDifferentStringTest()
		  Dim s1 As String = "Hello"
		  Dim s2 As String = "hello"
		  
		  // String matches with AreDifferent are case-sensitive
		  Assert.AreDifferent(s1, s2)
		  
		  s1 = s2
		  s1 = s1.DefineEncoding(Nil)
		  Assert.AreDifferent(s1, s2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualColorTest()
		  Dim c1 As Color = &c0000ff
		  Dim c2 As Color = &c0000ff
		  
		  Assert.AreEqual(c1, c2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualCurrencyTest()
		  Dim c1 As Currency = 42.38
		  Dim c2 As Currency = 40.00 + 2.38
		  
		  Assert.AreEqual(c1, c2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualDateTest()
		  Dim d1 As New Date
		  d1.SQLDate = "2012-11-30"
		  
		  Dim d2 As New Date
		  d2.SQLDate = "2012-11-30"
		  
		  Assert.AreEqual(d1, d2)
		  
		  d1 = Nil
		  d2 = Nil
		  
		  Assert.AreEqual(d1, d2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualDoubleDefaultTest()
		  Dim d1 As Double = 1.000000001
		  Dim d2 As Double = 1.000000002
		  
		  // Passes becaue the numbers are within the
		  // default tolerance of 0.00000001
		  Assert.AreEqual(d1, d2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualDoubleTest()
		  Dim d1 As Double = 1.01
		  Dim d2 As Double = 1.02
		  
		  // Passes becaue the numbers are within the tolerance of 0.01
		  Assert.AreEqual(d1, d2, 0.01)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualInt64Test()
		  Dim temp As UInt32 = 0
		  temp = temp - 1
		  
		  Dim i1 As Int64 = temp
		  Dim i2 As Int64 = temp
		  
		  Assert.AreEqual(i1, i2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualIntegerArrayTest()
		  Dim i1() As Integer = Array(1, 2, 3, 4, 5)
		  Dim i2() As Integer
		  i2.Append(1)
		  i2.Append(2)
		  i2.Append(3)
		  i2.Append(4)
		  i2.Append(5)
		  
		  Assert.AreEqual(i1, i2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualIntegerTest()
		  Dim i1 As Integer = 42
		  Dim i2 As Integer = 7*6
		  
		  Assert.AreEqual(i1, i2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreEqualMemoryBlockTest()
		  Dim m1 As MemoryBlock = "Hello"
		  Dim m2 As MemoryBlock = "Hello"
		  
		  Assert.AreEqual(m1, m2)
		  
		  m1 = Nil
		  m2 = Nil
		  
		  Assert.AreEqual(m1, m2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualStringArrayTest()
		  Dim s1() As String = Array("A", "B", "C")
		  Dim s2() As String
		  s2.Append("A")
		  s2.Append("B")
		  s2.Append("C")
		  
		  Assert.AreEqual(s1, s2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreEqualStringTest()
		  Dim s1 As String = "Hello"
		  Dim s2 As String = "hello"
		  
		  // Passes because string comparisons are case-insensitive
		  Assert.AreEqual(s1, s2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreNotEqualColorTest()
		  Dim c1 As Color = &c0000fe
		  Dim c2 As Color = &c0000ff
		  
		  Assert.AreNotEqual(c1, c2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreNotEqualDateTest()
		  Dim d1 As New Date
		  d1.SQLDate = "2012-11-29"
		  
		  Dim d2 As New Date
		  d2.SQLDate = "2012-11-30"
		  
		  Assert.AreNotEqual(d1, d2)
		  
		  d2 = Nil
		  
		  Assert.AreNotEqual(d1, d2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreNotEqualDoubleTest()
		  Dim d1 As Double = 1.01
		  Dim d2 As Double = 1.02
		  
		  // Passes because the numbers are not within the tolerance of 0.001
		  Assert.AreNotEqual(d1, d2, 0.001)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreNotEqualMemoryBlockTest()
		  Dim m1 As MemoryBlock = "hello"
		  Dim m2 As MemoryBlock = "Hello"
		  
		  Assert.AreNotEqual(m1, m2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreSameObjectTest()
		  Dim d1 As New Date
		  Dim d2 As Date
		  
		  d2 = d1
		  
		  Assert.AreSame(d1, d2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (not TargetHasGUI and not TargetWeb and not TargetIOS) or  (TargetWeb) or  (TargetHasGUI)
		Sub AreSameStringArrayTest()
		  Dim s1() As String = Array("A", "B", "C")
		  Dim s2() As String
		  s2.Append("A")
		  s2.Append("B")
		  s2.Append("C")
		  Assert.AreSame(s1, s2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AreSameStringTest()
		  Dim s1 As String = "Hello"
		  Dim s2 As String = "Hello"
		  
		  // String matches with AreSame are case-sensitive
		  Assert.AreSame(s1, s2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AssertFailedTest()
		  Assert.IsTrue(True)
		  Assert.IsFalse(Assert.Failed)
		  
		  If CurrentTestResult.Result = TestResult.Passed Then
		    Assert.IsTrue(False) // Intentional Fail
		    CurrentTestResult.Result = TestResult.Passed
		    Assert.IsTrue(Assert.Failed)
		    Assert.IsFalse(Assert.Failed)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub AsyncTest()
		  If AsyncTestTimer Is Nil Then
		    AsyncTestTimer = New Timer
		    AddHandler AsyncTestTimer.Action, WeakAddressOf AsyncTestTimer_Action
		  End If
		  
		  AsyncTestTimer.Mode = Timer.ModeSingle
		  AsyncTestTimer.Period = 500
		  AsyncAwait 3
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub AsyncTestTimer_Action(sender As Timer)
		  #Pragma Unused sender
		  
		  AsyncComplete
		  Assert.Pass "Async timer action ran as scheduled"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CleanSlate1Test()
		  Assert.AreEqual(0, Prop1)
		  Prop1 = Prop1 + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CleanSlate2Test()
		  Assert.AreEqual(0, Prop1)
		  Prop1 = Prop1 + 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub DoesNotMatchStringTest()
		  Dim actual As String = "abcde"
		  Dim pattern As String = "^\d+$"
		  
		  Assert.DoesNotMatch(pattern, actual)
		  
		  actual = "abcd"
		  pattern = "^(?-i)[A-Z]+$"
		  
		  Assert.DoesNotMatch(pattern, actual)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsFalseTest()
		  Assert.IsFalse(False)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsNilTest()
		  Dim d As Date
		  
		  Assert.IsNil(d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsNotNilTest()
		  Dim d As New Date
		  
		  Assert.IsNotNil(d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IsTrueTest()
		  Assert.IsTrue(True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit))
		Sub MatchesStringTest()
		  Dim actual As String = "12345"
		  Dim pattern As String = "^\d+$"
		  
		  Assert.Matches(pattern, actual)
		  
		  actual = "abcd"
		  pattern = "^[A-Z]+$"
		  
		  Assert.Matches(pattern, actual)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub NotImplementedTest()
		  // Tests will only return a result if one of the Assert methods
		  // are called. This test intentionally does nothing useful to
		  // simulate those times when a developer forgets to do this.
		  //
		  // It should report as "not implemented".
		  //
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PassTest()
		  Assert.Pass("Passed!")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setup1Test()
		  Assert.AreEqual(1, Prop2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Setup2Test()
		  Assert.AreEqual(1, Prop2)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TestMethodWithParamTest(param As String)
		  #Pragma Unused param
		  
		  Assert.Fail "A test method with a param should have been ignored"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TestTimersTest()
		  //
		  // Demonstrates the use of Test Timers
		  //
		  
		  StartTestTimer // key is optional
		  StartTestTimer("Part1")
		  StartTestTimer("Part2")
		  StartTestTimer("Part3")
		  StartTestTimer("Unused")
		  
		  Dim target As Double = Microseconds + 250000.0
		  While Microseconds < target
		    //
		    // Wait
		    //
		  Wend
		  
		  LogTestTimer("Part1", "initial")
		  LogTestTimer("Part3", "before reset")
		  StartTestTimer("Part3") // A Test Timer can be restarted at any time, even if not logged
		  
		  target = Microseconds + 500.0
		  While Microseconds < target
		    //
		    // Wait
		    //
		  Wend
		  
		  LogTestTimer("Part1", "done") // Reusing this as a way to creating a lap
		  LogTestTimer("Part2")
		  LogTestTimer("Part3", "after reset")
		  
		  //
		  // Timer "Unused" is never logged, and that's ok
		  //
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UnhandledExceptionTest()
		  //
		  // Create an exception
		  //
		  
		  Dim d As Dictionary // Nil!
		  
		  #Pragma BreakOnExceptions False
		  call d.Value(1)
		  #Pragma BreakOnExceptions Default
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private AsyncTestTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Prop1 As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Shared Prop2 As Integer
	#tag EndProperty


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
			Type="Integer"
			InheritedFrom="TestGroup"
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
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
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
			Type="String"
			InheritedFrom="TestGroup"
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
			Type="Integer"
			InheritedFrom="TestGroup"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
