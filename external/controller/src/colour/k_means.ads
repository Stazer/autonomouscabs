with Ada.Containers.Vectors;

with image_processing; use image_processing;

package k_means is
   
   type Point is record
      X, Y, Z : Long_Float;
   end record;
   
   package Point_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Point);
   use Point_Vector;
   
   package Cluster_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => Point_Vector.Vector);
   use Cluster_Vector;
   
   package RGBPixel_Vector is new Ada.Containers.Vectors
     (Index_Type => Natural, Element_Type => image_processing.RGBAPixel);
   use RGBPixel_Vector;
   
   flat_size : constant Integer := image_processing.height * image_processing.width;
   type Flat_Array is array(0 .. size - 1) of Point;
   
   procedure K_Means(img : in Image_Matrix; centroids : in out RGBPixel_Vector.Vector; k, n_iter : Integer);

end k_means;
