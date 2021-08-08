module WriteVTKTest

using AcousticAnalogies
using CCBlade

function doit(name)
    i = 11
    rpm = 2200.0
    omega = rpm*(2*pi/60.0)

    B = 2
    Rhub = 0.10
    Rtip = 1.1684  # meters
    radii = [
        0.92904E-01, 0.11751, 0.15631, 0.20097,
        0.24792    , 0.29563, 0.34336, 0.39068,
        0.43727    , 0.48291, 0.52741, 0.57060,
        0.61234    , 0.65249, 0.69092, 0.72752,
        0.76218    , 0.79479, 0.82527, 0.85352,
        0.87947    , 0.90303, 0.92415, 0.94275,
        0.95880    , 0.97224, 0.98304, 0.99117,
        0.99660    , 0.99932].*Rtip

    cs_area_over_chord_squared = 0.064
    chord = [
        0.35044     , 0.28260     , 0.22105     , 0.17787     , 0.14760,
        0.12567     , 0.10927     , 0.96661E-01 , 0.86742E-01 ,
        0.78783E-01 , 0.72287E-01 , 0.66906E-01 , 0.62387E-01 ,
        0.58541E-01 , 0.55217E-01 , 0.52290E-01 , 0.49645E-01 ,
        0.47176E-01 , 0.44772E-01 , 0.42326E-01 , 0.39732E-01 ,
        0.36898E-01 , 0.33752E-01 , 0.30255E-01 , 0.26401E-01 ,
        0.22217E-01 , 0.17765E-01 , 0.13147E-01 , 0.85683E-02 ,
        0.47397E-02].*Rtip

    theta = [
        40.005, 34.201, 28.149, 23.753, 20.699, 18.516, 16.890, 15.633,
        14.625, 13.795, 13.094, 12.488, 11.956, 11.481, 11.053, 10.662,
        10.303, 9.9726, 9.6674, 9.3858, 9.1268, 8.8903, 8.6764, 8.4858,
        8.3193, 8.1783, 8.0638, 7.9769, 7.9183, 7.8889].*(pi/180)
    rho = 1.226  # kg/m^3
    c0 = 340.0  # m/s

    rotor = Rotor(Rhub, Rtip, B)
    af = SimpleAF(2*pi, 0.0, 1.0, -1.0, 0.01, 0.02)
    sections = Section.(radii, chord, theta, Ref(af))
    Vinf = 0.11*c0
    ops = simple_op.(Vinf, omega, radii, rho)
    outs = solve.(Ref(rotor), sections, ops)

    bpp = 60/(rpm*B)
    period = 2*bpp
    num_source_times = 64
    ses = source_elements_ccblade(rotor, sections, ops, outs, fill(cs_area_over_chord_squared, length(radii)), period, num_source_times)

    # return ses
    # pvd1 = AcousticAnalogies.to_paraview_collection("$(name)-1-", ses[:, :, 1])
    # pvd2 = AcousticAnalogies.to_paraview_collection("$(name)-2-", ses[:, :, 2])
    # return pvd1, pvd2
    pvd = AcousticAnalogies.to_paraview_collection("$(name)-all-", ses)
end

end  # module
