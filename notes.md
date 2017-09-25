10 july 2017
-------
* based on the modified uvgen we wrote, a systematic gain offset between two antennaes of 1% will destroy the stokes V signal
* Ram said there are two options:
	* go through uncalibrated data in IDL, calibrate it and look for Stokes V that way. Hard
	* go through calibrated data (just plots) and look for a Stokes V signal that someone has just missed
* the uvplt command:
	* uvplt vis=test.Compact.vis device=2/xw nxy=2,2 stokes=v options=avall,nobase average=20 axis=time,real
	* stokes can be ll, rr, etc..
* I should probably get myself a copy of the book Ram gave to me
	* "Interferometry and Synthesis in Radio Astronomy" A. Richard Thompson, James M. Moran, et al. Second Edition
* Ram found a detection in 2008 data he took of orionkl

Non-Zeeman Circular Polarization is Widespread
Maps of the Magnetic Field in Several Nebulae and Supernova Remnants with Anisotropic Resonant Scattering
Mapping Velocity Flows with Anisotropic Resonant Scattering

11 july 2017
------------
* List of miriad tasks http://www.atnf.csiro.au/computing/software/miriad/taskindex.html
* the plan is
	* first trawl around the servers Ram linked me for people's unpublished calibrated data
	* failing that, learn how to reduce the data
* After a lot of hacking we got a no detection for NGC1333 (its too dim)
	* reconfigured miriad for the SMA and recompiled:
		* edited miriad/install/install.miriad and ran it
	* digging around in his script2.csh where all the reduction is done showed where he reduced for CO and that's how we got the Stokes V graph
* Josep Miquel found a strong Stokes V in old data of his form the envelope of an evolved star

12 july 2017
------------
* I might have to do something like this to create the stokes V data. This is from 101014_NGC1333_Ram/. Note that iras2a.win4 and iras2a.win4.chi were the only folders that showed me a reasonable plot of stokes V. Both those were generated from `uvaver`ing a folder called combined.usb.bp, a folder I've been ignoring thus far. Also, if I just look at combined.usb.bp without the `uvaver`ing, it looks like complete noise. The `uvaver`ing smoothes the plots and brings out structure.

```bash
GETCO:
set so="iras2a"
\rm -fr $so.win4
uvaver vis=combined.usb.bp out=$so.win4 select='so(iras2a),win(4)' interval=5
puthd in=$so.win4/evector value=0.7853
puthd in=$so.win4/mount value=4
puthd in=$so.win4/telescop value=sma

\rm -fr $so.win4.chi
uvredo vis=$so.win4 options=chi out=$so.win4.chi

goto terminate
```

Now the combined.usb.bp dataset is made from combined.usb with `uvaver`.

```bash
APPLYBP:
foreach sb(lsb usb)
\rm -fr combined.$sb.bp
uvaver vis=combined.$sb out=combined.$sb.bp options=nocal
end
goto terminate
```

And combined.usb is displayed with uvspec too! Now combined.usb is made from individual usb files:

```bash
COMBINE:
# 3c454.3 callisto neptune 3c84 iras2a
foreach sb(lsb usb)
\rm -fr combined.$sb
uvcat vis=3c454.3.$sb,neptune.$sb,callisto.$sb,3c84.$sb,iras2a.$sb out=combined.$sb
end
goto terminate
```

And iras2a.usb does not in fact work with uvspec! So now it looks like I have this scheme where a data file goes from failing with uvspec to a usable plot.

The steps in the script are:
COMBINE
FLAG
BPCAL
APPLYBP
RMLINE
AVER
EVEC
SPLIT
GETCO

So long as what adding my things after SPLIT is probably a safe place.
I tried this out on SMC data... and it worked! The following is the snippet I added based on GETCO

```bash
GETSTOKESV:
set so="smc.8"
\rm -fr $so.win4
uvaver vis=combined.usb.bp out=$so.win4 select="so(${so}),win(4)" interval=5
\rm -fr $so.win4.chi
uvredo vis=$so.win4 options=chi out=$so.win4.chi

goto terminate
```

The 'win(4)' actually selects a spectral window which narrows the spectral width you see in the plot, so if you want to see the whole range, take win(4) out! This snippet should hopefully "just work" as a drop in to any script2.csh:

```bash
GETSTOKES:
set so="smc.8"

set visin=combined.usb.bp
set stokesout=$so.stokes
set chiout=$stokesout.chi

\rm -fr $stokesout
uvaver vis=$visin out=$stokesout select="so(${so})" interval=5
\rm -fr $chiout
uvredo vis=$stokesout options=chi out=$chiout

echo "Made:"
echo $stokesout
echo $chiout

goto terminate
```

I think now this is the flow after dropping in that snippet:

```terminal
./script2.csh GETSTOKES
uvspec device=/xw options=avall,nobase axis=freq,amp nxy=1,1 interval=1000 stokes=i,v vis=${YOUR_SOURCE}.stokes
```

From here on the most recent snippet will be in reductionsnippet.sh

13 july 2017
------------
I should compile a list of all the pol project codes and search for them in Ram's folder. Even if he wasn't the PI he
helped with a lot of them. Example is 141028

more crash course stuff:
* device=1/xs lets you have a resizeable window (the 1 makes the window persistent)
* we saw that there was some structure to the SiO line that we previously thought had no signal.
	* turns out it was averageing out but if you look at the baselines individually there is positive and then negative
	  structure to the Stokes V signal and thats why it averages it. But its still there. The variations across baselines
	  has to do with the actual image of the region. One region gives a certain signal and others give a different signal.
	* folders:
		.cm : cleaned map
		.cl : model found by clean
		.mp : dirty map
		.bm : map of the point spread function?
	* slev=a,.25 a means absolute, 0.25 is the RMS. The s stands for sigma
	* imhist gives you a histogram of your image and tells you where the max and min are, as well as the rms
		* (x,y,channel,something else)
	* imspec in=example.cm region='box(x1,y1,x2,y2)'' will show you the spectrum averaged over that region
	* you use imhist to find where the maximum of an image is and then you can use imspec to get a good plot of your signal
	* prthd summarizes the dataset
		* like prthd in=orkl_080106.usb
* I wrote a way to maybe check if there is data present using prthd by grepping its output
	* `for d in */; do echo $d; prthd in=$d | grep "Total number of channels:"; done`
	* The folders with no data seem to not have a 'total number of channels' line
	* the uvlist task might also be useful for checking
* I found a signal in NGC7538 CO3->2

14 july 2017
------------
* i'm trying to figure out how to do idl2miriad. This cookbook has so far been useful:
	* https://www.cfa.harvard.edu/~cqi/mircook.html#htoc4
* I think the command is
	idl2miriad, dir='mwc480', source='mwc480', polar=1, sideband='u'
* I need to run 'csh' and source the thing the cookbook tells me

17 july 2017
------------
* a tiny offset in pointing between the LL and RR beams could create a Stokes V signal across the entire band. Josep Miquel did some self-calibration using the continuum to correct for this (because normally the calibration uses calibrators to figure out what the pointing error is, but I think the pointing error for the calibrator is very slightly different than for the source.)
	* actually I remembered something Ram said, the offset could happen between LL and RR because the waveplate is rotated between those two observations. It could be that the index of refraction of the plate is very slightly different between orientations, which makes the light bend slightly differently giving rise to an offset.
* I found a file called 'idl_notes' in tue 130831_L1448N_Maury dataset that shows how the data was reduced in IDL and then converted to miriad! It shows Tsys calibration, compiling a special idl2miriad script from Ram's folder, and then all the command that created the '.usb' and '.lsb' folders
* Found a series of lectures on radio astronomy and interferometry while looking for info about System Temperature:
	* https://web.njit.edu/~gary/728/
		* Lecture 1   Introduction to Radio Astronomy
		* Lecture 2   Radio Emission Mechanisms
		* Lecture 3   Radiative Transfer
		* Lecture 4   Primary Antenna Elements
		* Lecture 5   Front End Receiving Systems
		* Lecture 6   Fourier Synthesis Imaging
		* Lecture 7   The Receiving System for Interferometry
		* Lecture 8   More On Correlation
		* Lecture 9   Calibration
		* Lecture 10  Solar Radio Emission
		* Lecture 11  Solar Radio Emission (cont'd)
		* Lecture 12  Astronomical Radio Emission
* sometimes select='pol(ll,rr)' works even though stokes=i,v doesn't. Ram says its because the ll and rr data isn't sorted in time. So you have to do uvsort on the data. uvsort isn't even on the task index list (http://www.atnf.csiro.au/computing/software/miriad/taskindex.html) for miriad but it is in fact there.
* the uvaver task applies the gain calibration:
	* the flow is selfcal to calibrate and then uvaver to apply the calibration. You can use gpplt to look at the corrections and gpcopy to copy one calibration from one dataset to another before doing uvaver on that other dataset. That's the flow in Josep's offset correction anyway.
* ok this is a little unrelated but for a long time I would mull over how AI should learn things and I always focused on how a single individual algorithm should be designed. But something just hit me while I was looking at Josep Miquel's code.
	* Now as I understand it in learning scenarios you have some kind of scoring function and some evolution function and you evolve your solution, score it, and keep track of the solutions that get better. This is roughly how you might describe your own kind of learning; you try something, evaluate how it works, and then use that experience to inform future decisions.
	* but the downside of this, as I saw when I wrote 'genhello' (https://github.com/mef51/genhello) a million years ago is that the algorithm can get stuck going down the wrong path for a very long time. Or 'getting stuck in a local minimum'. And it was hard to get it to get out of that rut quickly. You could introduce more random solutions or have a more volatile evolution scheme but after a certain point its hard to randomly generate a solution in a few iterations that is better than the current solution we're stuck in after many iterations.
	* in addition to the 'single-track' scheme that an individual might use a big part of how we learn is we swap experiences and ask for advice from people we may have never known before but who have been working on a certain problem for a very long time. Talking with others and receiving their feedback is exactly how we avoid being stuck in a rut!
	* So the question is this: What is the effect of having several individual learning algorithms working independently for a while and then having request feedback from each other?
		* In my genhello program, this could be implemented by having several different processes concurrently calculating their own solutions. Then every n iterations or so, or whenever the solution is stuck in a rut (ie not improving after several iterations) the node can look for feedback from other nodes by requesting their current best solution. So instead of generating random solutions to try and get out of a rut that are ill-developed and unlikely to have a better score, you are checking with solutions that another node has been investigating for a while now. When you use solutions that are random they may in fact lead to much better solutions down the road, but it is impossible to tell without spending time computing it. Having multiple nodes lets you investigate multiple paths. For many nodes you can receive *lots* of different, well-developed solutions to inform your own solutions.
		* Once a node receives feedback from another node it can do several things:
			* It can create a new solution out of some combination of its and the feedback solution
			* It can choose to abandon its own solution in favor of the feedback solution if the score difference is large enough. This can lead to investigating 'subbranches' of solutions by independent nodes. (You could get "research groups" of nodes forming around a solution as an idea gets traction!)
			* A node create a combination solution and can spawn new nodes to distribute the work load and these new nodes would start from scratch. For example, if the evolution scheme is like simulated annealing where you have lots of variation at the beginning and then less as your iterations progress, the new nodes would start from the beginning with high variation, even if their spawning node was now late in the process with very little variation. These new nodes are like undergrad students, or fresh blood! They build off what came before them.
				* If we're spawning new nodes there should be a way to destroy old nodes. Or the creation of new nodes should be limited by available resources. You could also just reset a node (old node 'reinvents' itself) with some criteria like "I've swapped solutions with over 80% of the network and haven't found a better solution"
		* So I think that's the broad-strokes of my idea... Philosophically I think about the current knowledge of the human species and how it has been collected over many generations by many individuals. None of the huge advances were made independently without getting feedback from others. There are no examples in nature I can think of where a single living thing accomplished something impactful independently of the rest of the network, that is there is always information sharing.
		* I just remembered the internal monologue that spawned this idea. it was something like:
			"Barnard 1 is so fucking dim and boring. Why would you look at something so stupid and boring, why don't you try to do something great"
			"Well why don't you think of all the little things that were taken care of by lesser known individuals for the people who did great things. They never start from scratch."
		* Ok reality checking (or getting feedback from the rest of the network HEH):
			* I imagine this idea is already part of mindset of people who actually work in AI. There's already things like neural nets that incorporate the idea of a network in machine learning. I just don't know to what extent these are independent. How is my idea different from a neural net?
			* If I imagine the network of humans as a knowledge base in the form of the human species then is the network of neurons in the brain a knowledge base in the form of a human? Does all intelligence or awareness arise from a network of nodes that have a system for sharing information?
		* This fits in with the Boti idea I had. Boti was a general strategy I came up with based on NVC to specify how an individual learning loop should happen. (1. Observe, 2. Score/Feel, 3. Evaluate/Need, 4. Request/Develop new strategy). The main idea in Boti is that it could evolve the way it was generating a solution. Actually I think this is different. This idea is just a specific strategy for generating solutions.
			* Ok well Boti was always meant to be an independent node. Independent nodes could vary the way they generate solutions. But imagine you had a network of Botis. Then in this scheme: the Botis share their solutions with each other during the request stage.
		* Perhaps there is no individual without a group. You can't just make a single intelligent being. It's made up of smaller things. That's what I believe.
	* Concrete plan:
		* Modify genhello to spawn multiple nodes, have a basic scheme where nodes share solutions and use it to modify their own, then time how long it takes for the network as a whole to converge to the correct solution. Compare this with just a single node. If the time to solution for the network isn't much shorter than for a single node and doesn't decrease with the number of nodes... I'm wrong.
* Josep Miquel finished his selfcal thing to correct for the offset error (they kept calling it phase error) and it removed all the Stokes V signal. There is no Stokes V signal in his data after he corrects for the offset.
	* Even more, he was seeing Stokes V in some baselines and not others, just like I have been seeing in all the data I've looked at so far. So it could be that there is no Stokes V at all.
	* In Josep's data when we looked at all the baselines with no interval option we saw that a single baseline (6-8) had a huge jump in Stokes V over one scan... Our averaged signal was just coming from that one phase offset over one scan. This means that when you're checking individual baselines and you see a signal, its a good idea to check with no interval averaging if that signal is constant or if its just coming from one snippet of time.
	* the paper on that dataset https://ui.adsabs.harvard.edu/#abs/2012ApJ...751L..20G/abstract
* Holy fuck pressing 'escape' and then 'tab' when autocompleting a directory goes into your history instead of completing on every possible directory in the folder why have I never heard of this
* Okay the task now is to do the offset correction on the other sources and see if we still have a Stokes V
	* MapCont.csh generates a model of the Stokes I of the continuum that is then used in Correct_RR_LL_offset.csh to do the calibration. So you need to compute the model before you correct for the offset.
* the beam folder (those with extension .bm) are made by the invert task when the beam= option is specified.
* I'm going to try to do this on the 141028_ngc7538/ dataset
* It looks like there's a 10 step procedure laid out for reduction in 130824_SMC_Ram/Notes
* And that's all for Hilo folks! Heading back tomorrow at noon.

1 august 2017
-------------
* with uvspec you can use log=output.txt to dump the plotted data to a text file. if you specify multiple stokes=i,q,u,v it will just concatenate all the data

2 august 2017
-------------
* i need to figure out how to make the cont.i.cc file. It's a model of the source. I think CLEAN makes it. But it isn't in Josep's script. He might've made it on the command line.

3 august 2017
-------------
* databases of lines galore http://www.labastro.eu/databases-.html
* Josep uses IMSTAT to get his RMS... Its a lot lower than just looking at the plot
* The mapping of the continuum works, and so does the offset correction! You can clearly see the squint being reduced
after all this processing.
* The CO maps on the other hand aren't working. Invert is rejecting all the visibilities (it's flagging them as bad) for some reason. I want to try the following:
	* Redo split lines to select just one strongly peaked CO line. Right now I have all the dips and valleys. I'll pick the one CO line that has a Stokes V signal. Maybe that will work. I looked at the fortran code for invert and I found a block of code that checks the visibility against a 'weight' or a 'weight spectrum'. Whatever that is.

4 august 2017
--------------
* What does correcting for squint do to a true signal?
	* it preserves it: https://www.desmos.com/calculator/orhpp2fsr6
* the Orion signal was never more than 3 sigma

10 august 2017
---------------
* Talked with Martin:
	* smoothing dramatically (combining ten channels into one) is a way to increase the SNR
	* make a single map of CO instead of having panels over different km/s
	* SMA just sent out a call for proposals Deadline September 6
	* Arizona has a 12m dish at Kitt Peak, they're also taking proposals until September 17
		* need to see what their capabilities are, if they can do circular polarization or not
* averaging != integrating. Averaging the images isn't adding up all the images

25 august 2017
--------------
* orionCPARS

5 sept 2017
-----------
* 5sigma in co IRC+10216 when channels are averaged!

12 Sept 2017
------------
* might be possible to rewrite miriad.py to generate the functions
	* https://stackoverflow.com/questions/13184281/python-dynamic-function-creation-with-custom-names

13 Sept 2017
------------
* NGC7538 is a dim object but has two strong lines:
	* 345.8, CO
	* 346.6, who knows.
	* There is circular polarization in both of them. Orion had a line at 346.6 GHZ but no CP. In Orion the 346.6 GHz was weaker than the CO, but in NGC7538 the 346.6 line is stronger than the CO.
	* Ok this 346.6 line is cool, its significant, and its strong. What is it?
		* TODO:
			* write some utils for finding the RMS so I can figure out what's the best averaging
			* Correct for offset!
			* Find a control

14 Sept 2017
------------
* CH2CO is at 346.6 GHz (https://arxiv.org/pdf/astro-ph/0702066.pdf) in NGC7538

18 Sept 2017
------------
* The phase is uncalibrated in the NGC7538 data
* I used the wrong channel numbers when splitting continuum in Orion KL.
	* Josep Miquel also used the wrong channel numbers in IRC+10216
	* we both looked at tmp.4 when we should have looked at tmp.3
	* the quick fix (without changing channel numbers) is just tell uvlin to use tmp.4
* implement click on matplotlib window prints x,y relative to plot
	* https://stackoverflow.com/questions/25521120/store-mouse-click-event-coordinates-with-matplotlib
	* https://matplotlib.org/users/event_handling.html
	* https://stackoverflow.com/questions/15721094/detecting-mouse-event-in-an-image-with-matplotlib

19 Sept 2017
------------
* In NGC7538 CO stokes V got BIGGER after correction and ch2co17-16 disappeared.

21 Sept 2017
------------
* Other sources to look at:
	* HH211 (100111) (130121)
	* L1448N
	* IK Tau (101008)
	* Mira (080627)
* HH211 has lines in both the upper sideband and lower sideband. However I can't look at stokes with the lower sideband because I get this error:
	* Fatal Error [uvspec]:  Invalid number of polarisations for me to handle
	* there's probably a simple solution like uvaver or uvsort
		* see notes on july 12 and the GETSTOKES task
