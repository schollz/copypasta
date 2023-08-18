// Engine_CopyPasta
// to use, Ctl+F CopyPasta and replace with your name
Engine_CopyPasta : CroneEngine {

    // CopyPasta specific v0.1.0
    // OPINION: store everything in dictionaries
    //          because its easy to release
    // ALTERNATIVE: use specific variables
    var buses;
    var syns;
    var bufs; 
    var oscs;
    var parms;
    // CopyPasta ^

    *new { arg context, doneCallback;
        ^super.new(context, doneCallback);
    }

    alloc {
        // CopyPasta specific v0.0.1
        var s=context.server;

        // initialize all the dictionaries
        buses = Dictionary.new();
        syns = Dictionary.new();
        bufs = Dictionary.new();
        oscs = Dictionary.new();
        parms = Dictionary.new();

        // OPINION: oscs capture the output from SendReply in the
        // synthdefs and send it back to the norns script.
        // ALTERNATIVE: use polling (see habitus scripts)
        oscs.put("position",OSCFunc({ |msg| NetAddr("127.0.0.1", 10111).sendMsg("progress",msg[3],msg[3]); }, '/position'));

        // kick with two sends delayed and not delayed 
        SynthDef("kick", { |basefreq = 40, ratio = 6, sweeptime = 0.05, preamp = 1, amp = 1,
            decay1 = 0.3, decay1L = 0.8, decay2 = 0.15, clicky=0.0, busMain, busDelay, senddelay=0|
            var snd;
            var    fcurve = EnvGen.kr(Env([basefreq * ratio, basefreq], [sweeptime], \exp)),
            env = EnvGen.kr(Env([clicky,1, decay1L, 0], [0.0,decay1, decay2], -4), doneAction: Done.freeSelf),
            sig = SinOsc.ar(fcurve, 0.5pi, preamp).distort * env ;
            snd = (sig*amp).tanh!2;
            Out.ar(busMain,(1-senddelay)*snd);
            Out.ar(busDelay,senddelay*snd);
        }).send(s);

        // kick with two sends delayed and not delayed 
        SynthDef("main", { |busMain, busDelay|
            var snd;
            snd = In.ar(busMain,2);
            snd = snd + CombC.ar(In.ar(busDelay),0.1,0.1,1);
            Out.ar(0,snd);
        }).send(s);

        // create the two buses for the sends (using the dictionary)
        buses.put("busMain",Bus.audio(s,2));
        buses.put("busDelay",Bus.audio(s,2));

        // sync up the server
        s.sync;

        // create the main output synth
        syns.put("main",Synth.new("main",[
            busMain: buses.at("busMain"),
            busDelay: buses.at("busDelay"),
        ]));
        NodeWatcher.register(syns.at("main"));


        this.addCommand("kick","",{ arg msg;

        });

    }

    free {
        // CopyPasta Specific v0.0.1
        bufs.keysValuesDo({ arg buf, val;
            val.free;
        });
        syns.keysValuesDo({ arg name, val;
            if (val.class.asString=="List",{
                val.do({arg v; v.free;});
            },{
            val.free;
            });
        });
        buses.keysValuesDo({ arg buf, val;
            val.free;
        });
        bufsDelay.do(_.free);
        // ^ CopyPasta specific
    }
}
