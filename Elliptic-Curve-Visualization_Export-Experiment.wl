(* ::Package:: *)

EllipticCurvePointsModP[p_, a_, b_] := Module[{points = {}, y2EC, yEC}, 
  For[x = 0, x < p, x++, y2EC = Mod[x^3 + a*x + b, p];
   If[MemberQ[Table[Mod[i^2, p], {i, p}], y2EC], 
    yEC = Select[Range[0, p - 1], Mod[#^2, p] == y2EC &];
    points = Join[points, {x, #} & /@ yEC];];
  ];
  points
]

WeierstrassCurvePlot[iterations_, primes_, iterRev_] := Module[{c, a, p, xTorus, yTorus, zTorus, aCoeff, bCoeff, xElliptic, yElliptic, xMapped, yMapped, zMapped, fieldPoints, uMap, vMap, meshPoints, lines, labelPos, pointsOnCurve, mappedCurvePoints, myPlot, x, y, y2, i, revs},

(*Define radii of torus*)
c = 4;
a = 2;
p = primes;
(*Torus parametric functions*)
xTorus[u_, v_] = (c + a Cos[v]) Cos[u];
yTorus[u_, v_] = (c + a Cos[v]) Sin[u];
zTorus[u_, v_] = a Sin[v];

(*Elliptic curve parameters*)
aCoeff = 1;
bCoeff = 0;

(*Elliptic curve parametric functions*)
xElliptic[t_] = t;
yElliptic[t_] = Sqrt[t^3 + aCoeff*t + bCoeff];

(* Number of full revs *)
revs = Floor[iterations/iterRev];

(*Map the elliptic curve onto the torus*)
xMapped[pt_] := xTorus[uMap[pt[[1]]], vMap[pt[[2]]]];
yMapped[pt_] := yTorus[uMap[pt[[1]]], vMap[pt[[2]]]];
zMapped[pt_] := zTorus[uMap[pt[[1]]], vMap[pt[[2]]]];

(*Finite Field and Mesh Points*)
(*p = 17; (*Modulus*)*)
fieldPoints = Tuples[Range[0, p - 1], 2];
uMap[x_] := 2 Pi x/(p - 1) + Pi;
vMap[y_] := Pi (2 y/(p - 1) - 1) + Pi;
meshPoints = Map[Function[pt, {xTorus[uMap[pt[[1]]], vMap[pt[[2]]]], yTorus[uMap[pt[[1]]], vMap[pt[[2]]]], zTorus[uMap[pt[[1]]], vMap[pt[[2]]]]}], fieldPoints];
(*Generate lines for the mesh grid with translucent lines*)


(*Define the label for the (0,0) point on the torus*)
labelPos = {xTorus[uMap[0], vMap[0]], yTorus[uMap[0], vMap[0]], zTorus[uMap[0], vMap[0]]};
i=1;

pointsOnCurve = EllipticCurvePointsModP[p, aCoeff, bCoeff];

mappedCurvePoints = Map[Function[pt, {xMapped[pt], yMapped[pt], zMapped[pt]}], pointsOnCurve];
numMappedCurvePoints = Length[mappedCurvePoints];

(*Plotting*)
Show[
  ParametricPlot3D[
    {xTorus[u, v], yTorus[u, v], zTorus[u, v]}, 
    {u, 0, 2 Pi}, 
    {v, -Pi, Pi}, 
    PlotStyle -> Directive[White, Opacity[0.05]], 
    Mesh -> None,
    Lighting -> "Neutral"
  ], 
  Graphics3D[
    {
      Directive[White], 
      PointSize[Small],
      Cyan, 
      PointSize[Medium], 
      Point[mappedCurvePoints]
    }
  ], 
    (*Elliptic Curve # of Rev *)
If[revs > 0,
  Table[
    ParametricPlot3D[
      {xMapped[{u, yElliptic[u]}], yMapped[{u, yElliptic[u]}], zMapped[{u, yElliptic[u]}]}, 
      {u, (i - 1) * (p - 1), (i) * (p - 1)},
      PlotStyle -> Directive[Cyan, Thickness[0.002]]
    ],
    {i, 1, revs}
  ],
  {}  (* This is the output when revs <= 0 *)
],
If[revs > 0,
  Table[
    ParametricPlot3D[
      {xMapped[{u, yElliptic[u]}], yMapped[{u, yElliptic[u]}], -zMapped[{u, yElliptic[u]}]}, 
      {u, (i - 1) * (p - 1), (i) * (p - 1)},
      PlotStyle -> Directive[Cyan, Thickness[0.002]]
    ],
    {i, 1, revs}
  ],
  {}  (* This is the output when revs <= 0 *)
],
  (*Elliptic Curve*)
  If[Mod[iterations, iterRev] != 0,
    ParametricPlot3D[
      {xMapped[{u, yElliptic[u]}], yMapped[{u, yElliptic[u]}], zMapped[{u, yElliptic[u]}]}, 
      {u, (revs) * (p - 1), (iterations * (p - 1)/iterRev)}, 
      PlotStyle -> Directive[Cyan, Thickness[0.002]]
    ],
    {}
  ],
    If[Mod[iterations, iterRev] != 0,
    ParametricPlot3D[
      {xMapped[{u, yElliptic[u]}], yMapped[{u, yElliptic[u]}], -zMapped[{u, yElliptic[u]}]}, 
      {u, (revs) * (p - 1), (iterations * (p - 1)/iterRev)}, 
      PlotStyle -> Directive[Cyan, Thickness[0.002]]
    ],
    {}
  ],
  (*Line at x = 0*)
  ParametricPlot3D[
    {xTorus[Pi, v], yTorus[Pi, v], zTorus[Pi, v]}, 
    {v, -Pi, Pi}, 
    PlotStyle -> Directive[Magenta, Opacity[0.5], Thickness[0.003]]
  ],
  (*Parallel lines*)
  Table[
    ParametricPlot3D[
      {xTorus[u, v], yTorus[u, v], zTorus[u, v]}, 
      {v, -Pi, Pi}, 
      PlotStyle -> Directive[White, Opacity[0.1], Thickness[0.005]]
    ],
    {u, 0, 2 Pi, 2 Pi/(p - 1)}
  ],

  (*Line at y = 0*)
  ParametricPlot3D[
    {xTorus[u, 0], yTorus[u, 0], zTorus[u, 0]}, 
    {u, 0, 2 Pi}, 
    PlotStyle -> Directive[Red, Opacity[0.5], Thickness[0.003]]
  ],
    (*Meridian lines*)
  Table[
    ParametricPlot3D[
      {xTorus[u, v], yTorus[u, v], zTorus[u, v]}, 
      {u, 0, 2 Pi}, 
      PlotStyle -> Directive[White, Opacity[0.1], Thickness[0.005]]
    ],
    {v, 0, 2 Pi, 2 Pi/(p - 1)}
  ],
  Boxed -> False, 
  Axes -> False,
  Background -> Black,
  ViewProjection -> "Orthographic", 
  ViewPoint -> RotationTransform[iteration/10, {0, 0, 1}][{1.3, -2.4, 2.0}],  (* Adjust this line *)
  PlotRange -> All,
  ImageSize -> {800, 800}
]
];