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
