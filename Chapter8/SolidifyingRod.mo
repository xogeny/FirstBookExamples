model SolidifyingRod 
  extends BookExamples.Icons.RunnableExample;
  import Thermal.Basic1D;
  import BCs = Thermal.BoundaryConditions;
  import Modelica.SIunits;
  parameter SIunits.Length L=0.3 "Total length";
  parameter SIunits.Area A=4.0 "Cross-sectional area";
  parameter SIunits.Density rho=5.0;
  parameter SIunits.ThermalConductivity k=0.5;
  parameter SIunits.CoefficientOfHeatTransfer h=10;
  parameter Integer nsections=30 "# of sections";
  parameter SIunits.Length sec_L=L/nsections;
  // Components
  BookExamples.Chapter8.ThermalCapacitanceNL cap[nsections](
    each V=sec_L*A, 
    each rho=rho, 
    redeclare each BookExamples.Chapter8.SimplePropertyModel props(Tu=1010, 
        cp_m=90000));
  BCs.FixedTemperature Tr(T=1800);
  Basic1D.Conduction c_cond[nsections - 1](
    each L=sec_L, 
    each A=A, 
    each k=k);
  Basic1D.Convection r_conv(A=A, h=h);
  annotation (experiment(StopTime=1200), Commands(file="SolidifyingRod.mos" 
        "Simulate SolidifyingRod"));
equation 
  for i in 1:nsections - 1 loop
    connect(c_cond[i].a, cap[i].n);
    connect(c_cond[i].b, cap[i + 1].n);
  end for;
  connect(Tr.n, r_conv.b);
  connect(r_conv.a, cap[nsections].n);
end SolidifyingRod;
