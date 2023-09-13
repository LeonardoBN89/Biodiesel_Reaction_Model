# Biodiesel_Reaction_Model
In this work, it was developed a mathematical model for enzymatic production of biodiesel. Intermediate enzymatic complexes were considered.
The chemical reactions and species in this model are:

<img src="https://user-images.githubusercontent.com/144928827/267764111-28cac288-4b19-404e-95eb-766036a0c7f3.png"  width="550">

- Tri: triacylglycerol (in this case, forrage raddish oil; it can release up to three chains to esther);
- Di: diacylglycerol 
- Mo: monoacylglycerol
- Est: esther (the wanted product of reaction)
- EtOH: ethanol
- Gli: glycerol (the ending point of Tri)
- E (enzyme; lipase from Burkholderia cepacia).

  Applying chemical reactions principles and after algeabric manipulation, the system of differential equations is:

<img src="https://user-images.githubusercontent.com/144928827/267764005-3fedb731-677b-4d6e-bf11-f9c894528643.png"  width="800">

and the common denominator for the equations is:

<img src="https://user-images.githubusercontent.com/144928827/267766223-dc4a466a-228e-4dce-8674-d085aa21196d.png"  width="800">

The apparent rate of the reactions are given by a combination of the k parameters:

<img src="https://user-images.githubusercontent.com/144928827/267766828-b25d7523-76f3-47a2-85d1-fe0a100bab55.png"  width="300">


where:
- K<sub>d</sub> is a parameter of enzymatic thermal deactivation (hotter temperatures deactivate the enzyme faster);
- K<sub>in</sub> is a parameter of enzymatic deactivation by ethanol (higher concentration of ethanol deactivates the enzyme more);
