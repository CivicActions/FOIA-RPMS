XUSHSH ;SF-ISC/STAFF - PASSWORD ENCRYPTION ;03/10/95  15:46 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
 S X=$$EN(X)
 Q
EN(X) N XUA,XUI,XUJ,XUL,XUR,XUX,XUY,XUY1,XUZ D KE Q X
KE Q:X=""  S XUX=$E(X,1,20),X="",XUL=$L(XUX) D CL F XUZ=1:1 Q:$L(X)>19  D C S X=$S(XUZ#2:XUX_X,1:X_XUX)
 S X=$E(X,1,20)
 S X=$TR(X,$C(127,128))
 Q
B F XUI=0:0 Q:X'[$C(127)  S XUJ=$F(X,$C(127)),X=$E(X,1,XUJ-2)_$E(X,XUJ,20)
 F XUI=0:0 Q:X'[$C(128)  S XUJ=$F(X,$C(128)),X=$E(X,1,XUJ-2)_$E(X,XUJ,20)
 Q
C S XUR=0 F XUI=1:1:XUL S XUR=XUR+$A(XUX,XUI)
 S XUR=XUR#94
 F XUI=1:1:XUL S XUJ=$F(XUA(XUI),$E(XUX,XUI))-1+XUR\2,XUA(XUI)=$E(XUA(XUI),XUJ,999)_$E(XUA(XUI),1,XUJ-1)
 S XUY="" F XUI=1:1:XUL S XUY1=$F(XUA(XUI#XUL+1),$E(XUX,XUI))+33 S:XUY1=94 XUY1=-1 S XUY=XUY_$C(XUY1)
 S XUX=XUY Q
CL F XUI=1:1:XUL S XUA(XUI)=$P($T(Z+$A($E(XUX,XUI))+XUI#20+1),";",3,9)
 Q
Z ;;
 ;;&Qu9l) Jjk|1O+NpA=3*Lbv[(XF,zZWHgi>S"UM;0@.dIon}4_Pw-8qyC?K/YV6t7sE]f~x'D`TB%R#a{\!G<2$h5rc:me
 ;;-tFWg@0D[T2{MZLb/o8y.Jp3Oh7w:knRmqV~Xu#E]GYC+'!rP(4|ScBU"Nv*}z&da6j<e$H,xKA9\; s>?%`51I=il_fQ)
 ;;1ZsHoTnY;av~%0O+hX,gx[?qCFA/:6{V7|y*f}]258)4GUNl-Q_@r#cPW>$w kB3D"K(iLJ=!E'S<MRe&p.mjI\d`u9tzb
 ;;J02b7|*p>`WlOm6qI1Q\Me&)i.ETGwH"RLVu{oBv=P?8+X-j%A!(<]Z,gkh4FDc$}K9n5YC#af;x3/Uty~_N@'rS[sz: d
 ;;>uKF}QpBl;~A2DVO=eY</Em&onT.j#+,058"a$k!WN:7LM@\hGv]-3_41`'*y?UPwCZX% xIq{(fti)r9HSgRJb6cd|sz[
 ;;]z>}GUqT.K4ePp#;Msf"FHc8[J$I2%Sx-~3EurkgBV?\*iW|&_@=YZ 5b7/<9,`0:NyRaQlhv)X1Do6'({!mLjAtCO+nwd
 ;;6Bv>kYgj_GJFE`q]!H27usXz5ZxR%p.Kh{)tUe:~=LV@/[Sw1<Ob$#,8daoT\4cri?Al+Nn3IPmMy9*0"QW|'CfD&;}- (
 ;;_}+Fkea1<Z,SDh~ `Y62BHuN-JqO>5j(xsl3*!{G"T&M[/wW4PpiCLtUI9bm:r%fRV.@dQE0A]c\$o|y7;8g?)#=Kz'vnX
 ;;TZlp]~x%8,E.}|kMH9/!3a z`yWed0Ccm\jB#SgOfIJ&_(6s{K"@L);>P5<uYD2+nvVRb:'$?XNioqA17-rU=wFt*Gh[4Q
 ;;{.= Kt&vz8_`D;+BYc-GkQ"[gJd|]oInwyT'l>)e:XN3UVahiS0!9PqE$L?HA4,R/Mm2W~<*6pjrF#@uZ}5%7xbs(Of1\C
 ;;f6\W:mYiF.$"hR<XqE4_sdk-3T,yO#Ix}`r'n /C)tp9{=NBljLKgvuc[P&!>]VU~20zD+1A5H8%SGQ?@*(Zb|o7JM;aew
 ;;]'x[m!8OPYLQosE tw{$HuZv"*Gh;7N2.D~Ji3<%e)@a0fBU&dCR1A+=Mn\p|jzTyK`#/S_br:-V>FI96,}cq4l5?WXgk(
 ;;A{;0d/H$jg.Niy!:'tcah`&z\*"GTeO=MFI~Z5vbu>m_9)C}6Ps73%x]w[?Xrf+QKRqWB|<4EY8DSn1kL oV-@2#lU(Jp,
 ;;Aot4N!@'r/{Rk_<EC"B8l +6)YFz?ID:evMJ[SpZXPs9>f0\caKwU]%*y}GH,m7QdhT&b1V~-L5Ogx|qju=$`32(.Win;#
 ;;-xZ\h3_$9.7f>Be!*sT w"UAJ4{q[0mybrENS<dP&]~2i8Ia'MjcKYu;:Rn=G/)t?1W+#%5Q|l(v6pFO`D@V,oCkgzX}LH
 ;;mkU3n g/96z>Hx`C"fl5e#uw}Krj7_o*J+vbNR)h\XyOVZ@tE{QTM|]8;c?$PaBW:40,1dY%FG!L[i~D(A.2p=-S'&<sqI
 ;;pnRq(hW1)`Xt7D=9PaT*8<d+3/vIEQrcb-gBjYH]MSU#Nwis5.om_%Cu>}6~x{;|!FA\y ekKl,O&['?VG0:2@LZ$fJ4"z
 ;;RJfF>=}:0@(8tW-Aid6h*{/,)ON_B"MZHo.?I]Eek<yL5v3$`c[x~74aYqnDuz1bp+\2smlVCQSP#G&j;X9r%g' w!|TKU
 ;;o*B~e]p0lRY[=/`7CnfO'Wb2+sd3a,6#k{&LU(".qMNG$A%mg:J?Dwc!x5XvS;yj4t<uP@h_KT98 }\H1ZQ-rFi|I)>zVE
 ;;E7UvoK3Z%-y$2]s?}mBLQ!OVN'd58&+rk4;_ >u#/1PIt@<~x[G`WA"CMiq|pj=,:a)glXJn0RbwFfDz*e(\H9hc6.{TSY
 ;;
