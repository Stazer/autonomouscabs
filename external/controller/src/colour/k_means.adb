with image_processing; use image_processing;
with Ada.Numerics.Long_Elementary_Functions; use Ada.Numerics.Long_Elementary_Functions;
with Ada.Containers.Vectors;
with Ada.Text_IO; use Ada.Text_IO; 
with ada.numerics.discrete_random;
with Ada.Long_Float_Text_IO; use Ada.Long_Float_Text_IO;

with image_processing;

package body k_means is
   
   function Distance(a, b : Point) return Long_Float is
   begin
      return (a.X - b.X) ** 2 + (a.Y - b.Y) ** 2 + (a.Z - b.Z) ** 2;
   end Distance;
   
   function Pixel_To_Point(pixel : in image_processing.RGBAPixel) return Point is
      p : Point;
   begin
      p.X := Long_Float (pixel.B);
      p.Y := Long_Float (pixel.G);
      p.Z := Long_Float (pixel.R);
      return p;
   end Pixel_To_Point;
   
   function Point_To_Pixel(pt : in Point) return image_processing.RGBAPixel is
      p : image_processing.RGBAPixel;
   begin
      p.B := Colour_Value (pt.X);
      p.G := Colour_Value (pt.Y);
      p.R := Colour_Value (pt.Z);
      return p;
   end Point_To_Pixel;
   
   function Points_Equal (a, b  : Point) return Boolean is
   begin
      if a.X /= b.X then
         return False;
      end if;
      
      if a.Y /= b.Y then
         return False;
      end if;
      
      if a.Z /= b.Z then 
         return False;
      end if;
      
      return true;
   end Points_Equal;
   
   procedure K_Means_Setup(img : in Image_Matrix; 
                           flat : out Flat_Array;
                           centroids : in RGBPixel_Vector.Vector; 
                           cent : out Point_Vector.Vector;
                           k : Integer;
                           clusters : out Cluster_Vector.Vector) is
      package Rand_Row is new ada.numerics.discrete_random(image_processing.Row_Index);
      use Rand_Row;
      
      package Rand_Col is new ada.numerics.discrete_random(image_processing.Column_Index);
      use Rand_Col;

      gen_row : Rand_Row.Generator;
      gen_col : Rand_Col.Generator;
      
      row : Row_Index;
      col : Column_Index;
      
      centroid : Point;
      vec : Point_Vector.Vector;
      
      index : Integer := 0;
      pixel : image_processing.RGBAPixel;
   begin
      for I in image_processing.Row_Index loop
         for J in image_processing.Column_Index loop
            index := Integer(I) * width + Integer(J);
            pixel := img (I) (J);
            flat (index) := Pixel_To_Point (pixel);
         end loop;
      end loop;
      
      if centroids.Is_Empty then
         Reset(gen_row);
         Reset(gen_col);
      end if;    
      
      for I in 0 .. k - 1 loop
         if centroids.Is_Empty then
            row := Random(gen_row);
            col := Random(gen_col);
            centroid := Pixel_To_Point (img (row) (col));
            cent.Append (centroid);
         else
            centroid := Pixel_To_Point (centroids.Element (I));
            cent.Append (centroid);
         end if;
         clusters.Append (vec);
      end loop;
   end K_Means_Setup;
   
   procedure K_Means_Find_Cluster(flat : Flat_Array; k : in Integer;
                                  cent : in Point_Vector.Vector; 
                                  clusters : in out Cluster_Vector.Vector) is
      p, centroid : Point;
      min, dist : Long_Float;
      index : Integer;
      vec : Point_Vector.Vector;
   begin
      
      for I in 0 .. flat_size - 1 loop
         p := flat (I);
         min := Long_Float'Last;
         index := 0;
         for C in 0 .. k - 1 loop
            centroid := cent.Element (C);
            dist := Distance (p, centroid);
            if dist < min then
               min := dist;
               index := C;
            end if;
         end loop;
         vec := clusters.Element (index);
         vec.Append (p);
         clusters.Replace_Element (index, vec);
      end loop;
   end K_Means_Find_Cluster;
   
   procedure K_Means_Cluster_Centroid(cent : in out Point_Vector.Vector; 
                                      clusters : in out Cluster_Vector.Vector;
                                      done : out Boolean) is    
      sum : Point;
      size : Long_Float;
      index : Integer := 0;
   begin
      done := True;
      for V of clusters loop
         sum.X := 0.0;
         sum.Y := 0.0;
         sum.Z := 0.0;
         for P of V loop
            sum.X := sum.X + P.X;
            sum.Y := sum.Y + P.Y;
            sum.Z := sum.Z + P.Z;
         end loop;
         
         size := Long_Float (V.Length);
         if size /= 0.0 then
            --Put_Line ("size");
            sum.X := sum.X / size;
            sum.Y := sum.Y / size;
            sum.Z := sum.Z / size;
         
            if not Points_Equal (sum, cent.Element (index)) then
               cent.Replace_Element (index, sum);
               done := False;
            end if;
         end if;
         V.Clear;
         index := index + 1;
      end loop;
   end K_Means_Cluster_Centroid;
   
   procedure K_Means_Collect(cent : in Point_Vector.Vector; 
                             centroids : in out RGBPixel_Vector.Vector;
                             k : Integer) is
   begin
      centroids.Clear;
      for I in 0 .. k -1 loop
         centroids.Append (Point_To_Pixel (cent.Element (I)));
      end loop;
   end K_Means_Collect;
   
   procedure K_Means(img : in Image_Matrix; centroids : in out RGBPixel_Vector.Vector; k, n_iter : Integer) is
      cent : Point_Vector.Vector;
      clusters : Cluster_Vector.Vector;
      done : Boolean := False;
      flat : Flat_Array;
   begin
      K_Means_Setup (img, flat, centroids, cent, k, clusters);
      
      for I in 0 .. n_iter - 1 loop
         K_Means_Find_Cluster (flat, k, cent, clusters);
         K_Means_Cluster_Centroid (cent, clusters, done);
         if done = True then
            K_Means_Collect (cent, centroids, k);
            return;
         end if;
      end loop;
      K_Means_Collect (cent, centroids, k);
   end K_Means;                              
                               
end k_means;
