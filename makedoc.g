DustMakeDoc := function()
    MakeGAPDocDoc(Concatenation( PackageInfo( "dust" )[1]!.InstallationPath, "/doc" ),
            "dust",[
                    "../lib/storage.gd",
                    "../lib/stack.gd",
                    "../lib/queue.gd"
                    ],"dust");
end;