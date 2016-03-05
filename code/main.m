% default to run through everything

run_facemorphing = true;
run_mean_face = true;

if run_facemorphing == true
    disp('Running face morphing');
    run('facemorphing.m');
else
    disp('NOT running face morphing. Edit main.m to toggle');
end
if run_mean_face == true
    disp('Running mean_face');
    run('mean_face.m');
else
    disp('NOT running mean_face. Edit main.m to toggle');
end

disp('Done with script!');
