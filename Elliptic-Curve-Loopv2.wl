(* ::Package:: *)

(* Load your package *)
Get["C:\\Users\\jonwe\\OneDrive\\Documents\\GitHub\\EllipticCurveFiniteField\\Elliptic-Curve-Visualization_Export4.wl"]

(* Define the range and step for your loop *)
startValue = 101;
endValue = 1000;
stepValue = 1;
iteration = 1;
prime = {11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541};

(* For loop to perform operations and export images *)
For[iteration = startValue, iteration <= endValue, iteration += stepValue,
    (* Perform operation from your package *)
    result = WeierstrassCurvePlot[iteration, 29];  (* Replace with actual function and its parameters *)
    (* Export the image *)
    Export[FileNameJoin[{"C:\\Users\\jonwe\\OneDrive\\Pictures\\ECC2\\", "image_" <> IntegerString[iteration] <> ".png"}], result, ImageResolution -> 1200];
    ];

