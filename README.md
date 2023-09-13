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

<img src="https://user-images.githubusercontent.com/144928827/267766223-dc4a466a-228e-4dce-8674-d085aa21196d.png"  width="700">

The apparent rate of the reactions are given by a combination of the k parameters and will be treated this way, also being temperature dependent as an Arrhenius equation:

<img src="https://user-images.githubusercontent.com/144928827/267766828-b25d7523-76f3-47a2-85d1-fe0a100bab55.png"  width="260">

<img src="https://user-images.githubusercontent.com/144928827/267772024-5b9984a6-f022-4599-ae08-6a271fa2dd7f.png"  width="160">

and the equilibrium constants:

<img src="https://user-images.githubusercontent.com/144928827/267767454-4bcaf107-4031-4c0a-8cb3-720eb89b8dd9.png"  width="170">
where:

- K<sub>d</sub> is a parameter of enzymatic thermal deactivation (hotter temperatures deactivate the enzyme faster);
- K<sub>in</sub> is a parameter of enzymatic deactivation by ethanol (higher concentration of ethanol deactivates the enzyme more).

The unknown parameters (A<sub>i</sub>, Ea<sub>i</sub> and K<sub>i</sub>) were determined by the least squares method, implemented on MATLAB 7.0. The ODE system was solved with ode23s and the objective function were minimizes with genetic algorithm.

The parameters found were:

<img src="https://user-images.githubusercontent.com/144928827/267777588-e12c6cc3-cba9-4b89-a0fd-a76c54d78167.png"  width="530">

Despite the modeling for all reactions' steps, not all of them are significant. As can be seen in the graph below, the values of R<sub>2</sub>, R<sub>4</sub> and R<sub>5</sub> are very small and don't account for the overall reaction:

<img src="https://user-images.githubusercontent.com/144928827/267779703-270594fc-e35f-4ee2-b894-902ac18af1b3.png"  width="700">

The resulting concentration profiles for the measures species are:

<img src="https://user-images.githubusercontent.com/144928827/267779947-32322531-c0be-4aa2-8e86-0bba1ed679c4.png"  width="700">
