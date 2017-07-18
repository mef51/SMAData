# Meant as an add-on to the usual miriad reduction scripts I keep finding in Ram's folders.
# Doesn't run on its own.

CHECK:

for d in */; do
	echo $d
	prthd in=$d | grep "Total number of channels:"
done

# one liner:
# for d in */; do echo $d; prthd in=$d | grep "Total number of channels:"; done

GETSTOKES:
set so="smc.8"

set band=usb
set visin=combined.$band.bp
set stokesout=$so.$band.stokes
set chiout=$stokesout.chi

echo 'Starting with ' $visin

\rm -fr $stokesout
uvaver vis=$visin out=$stokesout select="so(${so})" interval=5
\rm -fr $chiout
uvredo vis=$stokesout options=chi out=$chiout

echo "Made:"
echo $stokesout
echo $chiout

goto terminate

SPEC:

set vis=ni4b_4x4.usb.stokes.chi

uvspec device=/xw options=avall,nobase axis=fre,amp nxy=1,1 interval=1000 stokes=i,v vis=$vis



goto terminate
