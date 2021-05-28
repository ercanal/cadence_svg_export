/*
Copyright 2018-2021 Ercan Altuntas
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

procedure( textsvg(text)
    let((pat string)
        pat=pcreCompile("<")
        string=pcreReplace(pat text "\\&lt;" 0)
        pat=pcreCompile(">")
        string=pcreReplace(pat string "\\&gt;" 0)
    )
)

procedure( shapesvg(cv transform textOut top inst paramList)
    let((points wirecolor fillcolor strokecolor lw svgtrans fs (debug nil) (text ""))
        minw=2*0.003125*nth(2 transform)
        lw=4*minw
        fs=4.5*4*minw
        foreach(shp cv~>shapes 
            wirecolor=if(equal(shp~>layerName "device") "green" "blue")
            case(shp~>objType
                ("line" 
                    points=dbTransformPointList(shp~>points transform)
                    when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                    ;<polyline points="20,20 40,25 60,40 80,120 120,140 200,180" style="fill:none;stroke:blue;stroke-width:3" />
                    pnt = car(points)
                    fprintf(of "<path d=\"M%g,%g " xCoord(pnt) yCoord(pnt))
                    foreach(pnt points
                        fprintf(of "L %g,%g" xCoord(pnt) yCoord(pnt))
                    )
                    fprintf(of "\" style=\"fill:none;stroke:%s;stroke-width:%g;stroke-linecap:round\" />\n" wirecolor lw)
                );line
                ("polygon"
                
                    fillcolor = if(equal(shp~>layerName "annotate")||equal(shp~>layerName "pin") "red" "none")
                    wirecolor = if(equal(shp~>layerName "annotate")||equal(shp~>layerName "pin") "none" wirecolor)
                    points=dbTransformPointList(shp~>points transform)
                    when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                    ;<polyline points="20,20 40,25 60,40 80,120 120,140 200,180" style="fill:none;stroke:blue;stroke-width:3" />
                    pnt = car(points)
                    fprintf(of "<path d=\"M%g,%g " xCoord(pnt) yCoord(pnt))
                    foreach(pnt points
                        fprintf(of "L %g,%g" xCoord(pnt) yCoord(pnt))
                    )
                    fprintf(of "Z\" style=\"fill:%s;stroke:%s;stroke-width:%g;stroke-linecap:round\" />\n" fillcolor wirecolor lw)
                );polygon
                ("label"
                    when(and( textOut or(or(or(top equal(shp~>layerName "pin")) equal(shp~>theLabel "cdsName()")) equal(shp~>theLabel "cdsParam(1)")))
                        if(equal(shp~>theLabel "cdsName()") then
                           theLabel = inst~>baseName
                           a=t
                        else if(equal(shp~>theLabel "cdsParam(1)") then
                           theLabel = nth(0 paramList)
                           a=t
                        else
                           theLabel = shp~>theLabel
                           a=nil
                        )
                        )
                        points=dbTransformBBox(shp~>bBox transform)
                        x = xCoord(lowerLeft(points))
                            y = yCoord(lowerLeft(points))
                            x1 = (xCoord(lowerLeft(points))+xCoord(upperRight(points)))/2
                            y1 = (yCoord(lowerLeft(points))+yCoord(upperRight(points)))/2
                            w = xCoord(upperRight(points))-x
                            h = yCoord(upperRight(points))-y
                            svgtrans=if(shp~>orient == "R90" sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x1 y1) "")
                            when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                            if(a
                            sprintf(text "%s <text x=\"%g\" y=\"%g\" alignment-baseline=\"middle\" text-anchor=\"middle\" style=\"fill:red;font-size:%g\" %s>%s</text>\n" text x1 y1  fs svgtrans textsvg(theLabel))
                        fprintf(of "<text x=\"%g\" y=\"%g\" alignment-baseline=\"middle\" text-anchor=\"middle\" style=\"fill:red;font-size:%g\" %s>%s</text>\n" x1 y1  fs svgtrans textsvg(theLabel))
                        )
                    )
                );label
                ("textDisplay"
                    when(and( textOut equal(shp~>layerName "pin"))
                            points=dbTransformBBox(shp~>bBox transform)
                            x = xCoord(lowerLeft(points))
                            y = yCoord(lowerLeft(points))
                            x1 = (xCoord(lowerLeft(points))+xCoord(upperRight(points)))/2
                            y1 = (yCoord(lowerLeft(points))+yCoord(upperRight(points)))/2
                            w = xCoord(upperRight(points))-x
                            h = yCoord(upperRight(points))-y
                            svgtrans=if(shp~>orient == "R90" sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x1 y1) "")
                            when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                            fprintf(of "<text x=\"%g\" y=\"%g\" alignment-baseline=\"middle\" text-anchor=\"middle\" style=\"fill:red;font-size:%g\"
                        %s>%s</text>\n" x1 y1  fs svgtrans textsvg(shp~>associate~>name))
                    )
                );textDisplay
                ("rect"
                    points=dbTransformBBox(shp~>bBox transform)
                    x = xCoord(lowerLeft(points))
                    y = yCoord(lowerLeft(points))
                    w = xCoord(upperRight(points))-x
                    h = yCoord(upperRight(points))-y
                    when(nequal(shp~>layerName "instance")
                        fillcolor = if(equal(shp~>layerName "pin") "red" "none")
                        strokecolor = if(equal(shp~>layerName "pin") "none" wirecolor)
                        when(t fprintf(of "<!-- %L -> %L -->\n" shp~>bBox points))
                        ;<rect width="300" height="100" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
                        fprintf(of "<rect x=\"%g\" y=\"%g\" width=\"%g\" height=\"%g\" style=\"fill:%s;stroke-width:%g;stroke:%s\" />\n"  x y w h fillcolor lw strokecolor )
                    )
                );rect
                ("ellipse"
                    let((x y cx cy rx ry)
                        points=dbTransformBBox(shp~>bBox transform)
                        x = xCoord(lowerLeft(points))
                        y = yCoord(lowerLeft(points))
                        cx = (xCoord(lowerLeft(points))+xCoord(upperRight(points)))/2
                        cy = (yCoord(lowerLeft(points))+yCoord(upperRight(points)))/2
                        rx = (xCoord(upperRight(points))-x)/2
                        ry = (yCoord(upperRight(points))-y)/2
                        fillcolor = if(equal(shp~>layerName "pin") "red" "none")
                        strokecolor = if(equal(shp~>layerName "pin") "none" wirecolor)
                        when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                        ;<ellipse cx="300" cy="100" rx="50" ry="40" style="fill:rgb(0,0,255);stroke-width:3;stroke:rgb(0,0,0)" />
                        fprintf(of "<ellipse cx=\"%g\" cy=\"%g\" rx=\"%g\" ry=\"%g\" style=\"fill:%s;stroke-width:%g;stroke:%s\" />\n"  cx cy rx ry fillcolor lw strokecolor )
                    )
                );ellipse
                ("arc"
                        points=shp~>ellipseBBox
                        x = xCoord(lowerLeft(points))
                        y = yCoord(lowerLeft(points))
                        cx = (xCoord(lowerLeft(points))+xCoord(upperRight(points)))/2
                        cy = (yCoord(lowerLeft(points))+yCoord(upperRight(points)))/2
                        rx = (xCoord(upperRight(points))-x)/2
                        ry = (yCoord(upperRight(points))-y)/2
                        apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                        cy+ry*sin(shp~>stopAngle)))
                        points=dbTransformPointList(apoints transform)
                        when(t fprintf(of "%L\n" list( cx cy rx ry nth(1 transform))))
                        when(t fprintf(of "<!-- %L -> %L -->\n" apoints points))
                        fprintf(of "<path d=\"M%g,%g " xCoord(nth(0 points)) yCoord(nth(0 points)))
                        fprintf(of "A %g,%g 0 0 0 %g,%g" rx*nth(2 transform) ry*nth(2 transform)  xCoord(nth(1 points)) yCoord(nth(1 points)))
                        fprintf(of "\" style=\"fill:%s;stroke:%s;stroke-width:%g;stroke-linecap:round\" />\n" "none" wirecolor lw)
                ) ;arc
            );case
        );foreach
        text
    );let
);proc


let((cv of scale lw fs transform_0 transform_scale transform box transform_cv)
    cv=geGetWindowCellView()
    of=outfile("test1.svg")
    scale=320
    box=cv~>bBox
    x = xCoord(lowerLeft(box))
    y = yCoord(lowerLeft(box))
    w = xCoord(upperRight(box))-x
    h = yCoord(upperRight(box))-y
    ;transform_0=list(list(0 0) "MX" 1)
    transform_0=list(list(-x -(y+h)) "R0" 1)
    transform_1=list(list(0 0)  "MX" 1)
    ;transform_0=list(list(0 0) "R0" 1)
    transform_scale=list(list(0 0) "R0" scale)
    transform=dbConcatTransform(dbConcatTransform( transform_0 transform_1) transform_scale )
    box=dbTransformBBox(cv~>bBox transform)
    ;println(box)
    x = xCoord(lowerLeft(box))
    y = yCoord(lowerLeft(box))
    w = xCoord(upperRight(box))-x
    h = yCoord(upperRight(box))-y
    println(transform)
    ;println(y)
    fprintf(of "<svg width=\"%g\" height=\"%g\">\n" w h)
    shapesvg(cv transform t t nil nil)
    transform_cv=transform
    foreach(inst cv~>instances
        paramList=list()
        transform = dbConcatTransform( inst~>transform transform_cv )
        ;fprintf(of "<g> <!-- %L  -->\n" inst~>cellName)
        if( nequal(inst~>master~>libName  "basic")
            text=shapesvg(inst~>master transform t nil inst paramList)
            text=shapesvg(inst~>master transform nil nil inst paramList)
        )
        ;fprintf(of "</g><!-- %L  -->\n" inst~>cellName)
        fprintf(of "%s\n" text)
    )
    fprintf(of "</svg>\n")
    close(of)
)
