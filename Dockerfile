FROM mycluster.icp:8500/ace/ace-dev-only:latest

COPY bars_aceonly /home/aceuser/bars
RUN ace_compile_bars.sh
