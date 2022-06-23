/*
Copyright 2018-2022 Ercan Altuntas
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
        pat=pcreCompile("&")
        string=pcreReplace(pat text "\\&amp;" 0)
        
        pat=pcreCompile("<")
        string=pcreReplace(pat string "\\&lt;" 0)
        pat=pcreCompile(">")
        string=pcreReplace(pat string "\\&gt;" 0)
    ); let
);textsvg

procedure( getInstParameter( inst )
    let((cdf ParamName ParamText)
        paramList=list()
        cdf= cdfGetInstCDF(inst)
        ;println(get(inst "cellName"))
        if( cdf~>paramLabelSet then
            ;println(cdf~>paramLabelSet)
            foreach( ParamName parseString(cdf~>paramLabelSet)
                if( get(inst ParamName) then
                    if(  get(inst ParamName) != "" then
                          if(stringp(get(inst ParamName)) 
                              sprintf( ParamText "%s=%s" ParamName get(inst ParamName)) 
                              sprintf( ParamText "%s=%L" ParamName get(inst ParamName)) 
                          )
                        paramList = append1( paramList ParamText)
                    else
                        paramList = append1( paramList "" )
                    )
                )
            )
        )
        ;println(paramList)
        paramList
    ); let
)


procedure( TextParsing( shape transform shapecolor theLabel)
    let( (dominant_baseline text_anchor point0 x0 y0 fs instOrient svgtrans MultiLine)
        case( shape~>justify
            ("upperLeft"
                dominant_baseline = "hanging"
                text_anchor       = "start"
            )
            ("upperCenter"
                dominant_baseline = "hanging"
                text_anchor       = "middle"
            )
            ("upperRight"
                dominant_baseline = "hanging"
                text_anchor       = "end"
            )
            ("centerLeft"
                dominant_baseline = "central"
                text_anchor       = "start"
            )
            ("centerCenter"
                dominant_baseline = "central"
                text_anchor       = "middle"
            )
            ("centerRight"
                dominant_baseline = "central"
                text_anchor       = "end"
            )
            ("lowerLeft"
                dominant_baseline = ""
                text_anchor       = "start"
            )
            ("lowerCenter"
                dominant_baseline = ""
                text_anchor       = "middle"
            )
            ("lowerRight"
                dominant_baseline = ""
                text_anchor       = "end"
            )
            (t
                printf( "Unknow text justify %s\n" shape~>justify)
                dominant_baseline = "central"
                text_anchor       = "middle"
            )
        ) ; case_shape~>justify
        
        point0 = dbTransformPoint(shape~>xy transform)
        x0 = nth(0 point0)
        y0 = nth(1 point0)
        fs = shape~>height*400
        instOrient = nth(1 transform)
        
        when(t fprintf(of "<!-- %L -->\n" list( "shape~>orient" shape~>orient "instOrient" instOrient )))
                
        svgtrans = case(shape~>orient 
            ("R0"
                case(instOrient
                    ("R0"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                            ( t
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                            ( t
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                            ( t
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                            ( t
                            )
                        ) ;case_text_anchor
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf( "R0 Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;R0
            ("R90" 
                case(instOrient
                    ("R0"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf( "R90 Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;R90
            ("R180" 
                case(instOrient
                    ("R0"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf("R180 Unknow instance orient %s \n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;R180
            ("R270" 
                case(instOrient
                    ("R0"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R90"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf("R270 Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;R270
            ("MX"
                case(instOrient
                    ("R0"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf("MX Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;MX
            ("MXR90"
                case(instOrient
                    ("R180"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( dominant_baseline  
                            (""  
                                dominant_baseline = "hanging"
                            )
                            ("hanging"
                                dominant_baseline = ""
                            )
                        ) ; case_dominant_baseline
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf( "MXR90 Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;MXR90
            ("MY"
                case(instOrient
                    ("R0"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("R180"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("R270"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MXR90"
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    ("MY"
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MYR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf( "MY Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;MY
            ("MYR90"
                case(instOrient
                    ("MXR90"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(0,%g,%g)\"" x0 y0)
                    )
                    ("MX"
                        case( text_anchor 
                            ("end" 
                                text_anchor = "start"
                            )
                            ("start"
                                text_anchor = "end"
                            )
                        ) ;case_text_anchor
                        sprintf(nil "transform=\"rotate(-90,%g,%g)\"" x0 y0)
                    )
                    (t
                        printf( "MYR90 Unknow instance orient %s\n" instOrient)
                        ""
                    )
                ) ; case_instOrient
            ) ;MYR90
            ( t
                printf( "Unknow  orient %s\n" shape~>orient)
                ""
            )
        )
        MultiLine = parseString(theLabel "\n")
        if( and(length(MultiLine) > 1, dominant_baseline == "" ) then
            y0 = y0 - length(MultiLine)* fs
        )
        sprintf(text    "<text x=\"%g\" y=\"%g\" dominant-baseline=\"%s\" text-anchor=\"%s\" style=\"fill:%s; white-space: pre;font-size:%gpx\" %s>%s</text>\n" x0 y0 dominant_baseline text_anchor shapecolor fs svgtrans textsvg(theLabel))
    ); let
); TextParsing

procedure( shapesvg(cv transform textOut top inst paramList paramOut )
    let((points wirecolor fillcolor strokecolor lw svgtrans fs inst0 (debug nil) (text ""))
        minw=2*0.003125*nth(2 transform)
        lw=1.25*minw
        fs=6.5*1*minw
        foreach(shp cv~>shapes 
            wirecolor=if(equal(shp~>layerName "device") "green" "blue")
            shpcolor= case( shp~>layerName
                ("device"
                    "green"
                )
                ("pin"
                   "red" 
                )
                ("wire"
                   "blue" 
                )
                ("text"
                   "Black" 
                )
                ("instance"
                   "red" 
                )
                ("annotate"
                   "brown" 
                )
                ("border"
                    "gray"
                )
                ( nil
                    "blue"
                )
                ( t
                    printf( "Unknown layerName %s" shp~>layerName)
                    "blue"
                )
            )
            wirecolor = shpcolor
            ;println(shp~>objType)
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
                ("path"
                    points=dbTransformPointList(shp~>points transform)
                    pnt = car(points)
                    fprintf(of "<path d=\"M%g,%g " xCoord(pnt) yCoord(pnt))
                    foreach(pnt points
                        fprintf(of "L %g,%g" xCoord(pnt) yCoord(pnt))
                    )
                    fprintf(of "\" style=\"fill:none;stroke:%s;stroke-width:%g;stroke-linecap:round\" />\n" wirecolor lw*shp~>width/0.00625 )
                ); path
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
                    if(and( textOut or(
;                      or(top equal(shp~>layerName "pin")) 
                      or(top t) 
                      )) then
                                    
                        theLabel = shp~>theLabel
                        a=t
                        StartIndex = nindex(theLabel, "cdsParam(")
                        ;println(theLabel)
                        if( StartIndex then
                                        
                            if( paramOut then
                                EndIndex = nindex( substring( theLabel StartIndex), ")")
                                Index = readstring(substring( theLabel StartIndex+9 EndIndex-10))
                                if( Index < length(paramList)+1 then
                                    sprintf(TextParam "cdsParam(%d)" Index)
                                    rexCompile(TextParam)
                                    theLabel=rexReplace(theLabel strcat("\"" nth(Index-1 paramList) "\"") 0)
                                    if( errset(evalstring(theLabel)) then
                                            theLabel=evalstring(theLabel)
                                    else
                                            a=nil
                                    )
                                else
                                    a=nil
                                )
                            else 
                                a=nil
                            )
                        ); if StartIndex
                        ;println(theLabel)
                        when( strncmp( theLabel "[@" 2) == 0 
                                  
                            EndIndex = nindex( substring( theLabel 3), "]")
                            theLabel = substring(theLabel 3 EndIndex-1)
                            theLabel = nth(0 parseString(theLabel ":"))
                            
                            case(theLabel
                                ("instanceName"
                                    theLabel = get(inst "name")
                                    shpcolor = "brown"
                                    if(theLabel == nil then
                                        theLabel = "[@instanceName]"
                                    )
                                )
                                ("partName"
                                    theLabel = get(inst "cellName")
                                    if(theLabel == nil then
                                        theLabel = "[@partName]"
                                    )
                                )
                                (t
                                    theLabel = get(inst theLabel)
                                    if( theLabel == nil then
                                        printf( "Undefined Label %s\n" shp~>theLabel)
                                        theLabel =""
                                        a=nil
                                    ) 
                                )
                            )
                        ); if strncmp( theLabel "[@" 2) == 0
                        when(strncmp( theLabel "ilInst~>" 8) == 0 
                                         
                            rexCompile("ilInst~>")
                            theLabel = rexReplace(theLabel "inst~>" 0)
                            if( errset(evalstring(theLabel)) then
                                theLabel=evalstring(theLabel)
                            else
                                a=nil
                            )
                        )
                        
                        case(theLabel
                            ("cdsName()"
                                              
                                theLabel = inst~>name
                            )
                            ( t
                                if( strncmp("cdsTerm(" theLabel 8) == 0 then
                                    a=nil
                                    theLabel=""
                                )
                                if( and( nindex(theLabel, "(") (shp~>labelType != "normalLabel")) then
                                  ;shp~>labelType == "ILLabel"
                                  rexCompile("ilInst~>")
                                  theLabel = rexReplace(theLabel "inst~>" 0)
                                  ;println(theLabel)
                                  if(errset(evalstring(theLabel)) then
                                      theLabel=evalstring(theLabel)
                                        else
                                      a=nil
                                  )
                                  ;println(theLabel)
                                ;else
                                  ;println(shp~>labelType)
                                )

                            )
                        ) ; case_theLabel
                        
                        fprintf(of "<!-- %L -> %L  -->\n" shp~>xy points )
                        when(debug fprintf(of "<!-- %L -> %L -->\n" shp~>points points))
                        if(a then
                            fprintf(of "%s" TextParsing( shp transform shpcolor theLabel))
                        )
                    else
                      printf( "Undisplayed Label:%s with Layer name:%s\n" shp~>theLabel shp~>layerName)
                    )
                );label
                ("textDisplay"
                    if( and( textOut equal(shp~>layerName "pin")) then
                            fprintf(of "%s" TextParsing( shp transform shpcolor shp~>associate~>name))
                    else
                      if( shp~>theLabel != nil then 
                          println(shp~>theLabel)
                          println(shp~>layerName)
                      )
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
                        fillcolor = case( shp~>layerName 
                            ("pin" 
                                "red"
                            ) 
                            ("wire" 
                                "blue"
                            ) 
                            (t 
                                "none"
                            )
                        )
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
                        case( nth(1 transform)
                            ( "R0"
                                apoints = list(list(cx+rx*cos(shp~>stopAngle) cy+ry*sin(shp~>stopAngle)) list(cx+rx*cos(shp~>startAngle) 
                                cy+ry*sin(shp~>startAngle)) )
                            )
                            ( "R90"
                                apoints = list(list(cx+rx*cos(shp~>stopAngle) cy+ry*sin(shp~>stopAngle)) list(cx+rx*cos(shp~>startAngle) 
                                cy+ry*sin(shp~>startAngle)) )
                            )
                            ( "R180"
                                apoints = list(list(cx+rx*cos(shp~>stopAngle) cy+ry*sin(shp~>stopAngle)) list(cx+rx*cos(shp~>startAngle) 
                                cy+ry*sin(shp~>startAngle)) )
                            )
                            ( "R270"
                                apoints = list(list(cx+rx*cos(shp~>stopAngle) cy+ry*sin(shp~>stopAngle)) list(cx+rx*cos(shp~>startAngle) 
                                cy+ry*sin(shp~>startAngle)) )
                            )
                            ( "MX"
                                apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                                cy+ry*sin(shp~>stopAngle)))
                            )
                            ( "MXR90"
                                apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                                cy+ry*sin(shp~>stopAngle)))
                            )
                            ( "MY"
                                apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                                cy+ry*sin(shp~>stopAngle)))
                            )
                            ( "MYR90"
                                apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                                cy+ry*sin(shp~>stopAngle)))
                            )
                            ( t
                                apoints = list(list(cx+rx*cos(shp~>startAngle) cy+ry*sin(shp~>startAngle))  list(cx+rx*cos(shp~>stopAngle)
                                cy+ry*sin(shp~>stopAngle)))
                                printf("Arc Tranfomation Unknow %s\n" nth(1 transform))
                            )
                        ) ; case_nth(1 transform)
                        points=dbTransformPointList(apoints transform)
                        when(t fprintf(of "%L\n" list( cx cy rx ry nth(1 transform))))
                        when(t fprintf(of "<!-- arc %L -> %L -->\n" apoints points))
                        fprintf(of "<path d=\"M%g,%g " xCoord(nth(0 points)) yCoord(nth(0 points)))
                        fprintf(of "A %g,%g 0 0 0 %g,%g" rx*nth(2 transform) ry*nth(2 transform)  xCoord(nth(1 points)) yCoord(nth(1 points)))
                        fprintf(of "\" style=\"fill:%s;stroke:%s;stroke-width:%g;stroke-linecap:round\" />\n" "none" wirecolor lw)
                ) ;arc
                ( t
                     printf( "Unknow shape type %s\n" shp~>objType)
                )
            );case
        );foreach
        if( top == nil then
            foreach(inst0 cv~>instances
                shapesvg(inst0~>master dbConcatTransform(inst0~>transform transform) t nil inst paramList paramOut)
            ); foreach
        );if
        text
    );let
);proc

procedure( eaSvgExport(filename @optional (paramOut t) (cv geGetWindowCellView()) )
let((of scale lw fs transform_0 transform_scale transform box transform_cv)
    of=outfile(filename)
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
    ;println(filename)
    ;println(paramOut)
    ;println(y)
    fprintf(of "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" width=\"%g\" height=\"%g\">\n" w h)
    shapesvg(cv transform t t nil nil paramOut )
    transform_cv=transform
    foreach(inst cv~>instances
        paramList=getInstParameter(inst)
        transform = dbConcatTransform( inst~>transform transform_cv )
        fprintf(of "<g> <!-- %L  -->\n" list(inst~>libName inst~>cellName))
        if( nequal(inst~>master~>libName  "basic")
            ; Print Symbol
            text=shapesvg(inst~>master transform t nil inst paramList paramOut )
            text=shapesvg(inst~>master transform nil nil inst paramList paramOut )
        )
        fprintf(of "</g><!-- %L  -->\n" inst~>cellName)
        ;fprintf(of "%s\n" text)
    )
    fprintf(of "</svg>\n")
    close(of)
)

);eaSvgExport
eaSvgExport("test1.svg" )
eaSvgExport("test1noparam.svg" nil)
