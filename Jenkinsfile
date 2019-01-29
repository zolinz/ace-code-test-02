node {

    imageName = "mycluster.icp:8500/ace/aceappzoli8"



   stage('clone repo'){
    checkout scm
   }
/*

   stage('clone app source code'){
    git branch: 'master', url: 'https://github.com/zolinz/ace-code-test-02.git'
   }
*/

   stage('build bar file'){
     sh """#!/bin/bash
            /usr/bin/Xvfb :100 &
             export DISPLAY=":100"
             cd /opt/ibm/ace-11.0.0.2
             ./ace make registry global accept license silently
            . /opt/ibm/ace-11.0.0.2/server/bin/mqsiprofile
            cd /root/workspace
            pwd
            echo \$OLDPWD
            ls | egrep  '.*[^tmp]\$'
            CODE_DIR=`ls | egrep  '.*[^tmp]\$'`
            export CODE_DIR
            echo \$CODE_DIR
           #sleep infinity
           echo /root/workspace/\${CODE_DIR}
            mqsicreatebar -data /root/workspace/\${CODE_DIR}/ -b zolitest2.bar -a MyRest2
            mqsicreatebar -data /root/workspace/\${CODE_DIR}/ -b zolitest2.bar -a MyRest2
            cd \${CODE_DIR}
            mkdir bars_aceonly
            chmod 777 bars_aceonly
            cp /root/workspace/\${CODE_DIR}/zolitest2.bar bars_aceonly
       """

   }


   stage('build image and push to ICP registry'){


        sh """
        #!/bin/bash
        sleep infinity
        cp /root/workspace/zolitest2.bar /root/workspace/ibm-ace-test

        docker login  -u admin -p admin mycluster.icp:8500
        docker build -t ${imageName} .
        docker push ${imageName}
        """
   }

/*

   stage('test helm install'){
    sh"""
    #!/bin/bash

   #kubectl create serviceaccount --namespace kube-system tiller
   #kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
   #kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

   #sysctl -w net.ipv6.conf.all.disable_ipv6=1


   helm init --client-only --debug
   sleep infinity
   helm version --tls
   helm list --tls



    """
   }

*/
   stage('deploy new image'){

        sh """
        docker login  -u admin -p admin mycluster.icp:8500
       kubectl get image aceappzoli8 -n=ace -o yaml | sed 's/scope: namespace/scope: global/g' | kubectl replace -f -
         kubectl set image deployment/zoli-ace-01-ibm-ace zoli-ace-01-ibm-ace=${imageName}


         kubectl rollout status deployment/zoli-ace-01-ibm-ace

        """

   }


}
