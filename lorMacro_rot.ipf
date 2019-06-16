// Contents   : NMR spectrum rotation and fitting
// Need       : NMRfunc(macro),NMRX file
// Author     : Tsunakawa
// LastUpdate : 2019/06/13
// Since      : 2018/08/01
// Igor Version : 6.2.2.0


Macro lorMacro_rot(i,j,k)
 Variable i,j,k,l
 Prompt i,"frequency"
 Prompt j,"phase"
 Prompt k,"degree"
// Prompt l,"att"
// Prompt m,"Cu"
 
string/G name_n =  num2str(k) + "deg"
string/G name_f = "f_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_x = "x_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_y = "y_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_FM = "FMHz_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_th = "th_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_XF = "xr_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_YF = "yr_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"
string/G name_fitXF = "fit_xr_" + "_" + num2str(k) + "deg" + num2str(i) + "MHz"

rename wave0,$(name_f)
rename wave1,$(name_x)
rename wave2,$(name_y)

duplicate $(name_f) $(name_FM)
$(name_FM) = $(name_f) / 1000 + i
duplicate $(name_f) $(name_th)
$(name_th) = j*pi/180

duplicate $(name_f) $(name_XF),$(name_YF)
$(name_XF) = $(name_x)*cos($(name_th)) - $(name_y)*sin($(name_th))
$(name_YF) = $(name_x)*sin($(name_th)) + $(name_y)*cos($(name_th))

display $(name_XF) vs $(name_FM) as num2str(k) + "deg" + num2str(i) + "MHz"
ModifyGraph mode=3
ModifyGraph tick=2,mirror=1,standoff=0,font="Times New Roman";DelayUpdate
Label left "\\f00Intensity";DelayUpdate
Label bottom "\\f02F\\f00 (MHz)"


Make/D/N=3/O W_coef
W_coef[0] = {6000,0.01,i}
FuncFit/NTHR=0/TBOX=832 NMRlor W_coef  $(name_XF) /X=$(name_FM) /D
ModifyGraph rgb($(name_fitXF))=(0,0,65280)

End