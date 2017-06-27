#!/bin/bash

function getPod {
  echo "$(kubectl get pods --all-namespaces | grep $1)"
}

function getPodName {
  echo $(getPod $1 | awk '{ print $2 }')
}

function execInPod {
  pod=$(getPod $1)
  shift
  kubectl exec -ti $(echo $pod|awk '{print $2}') --namespace=$(echo $pod | awk '{print $1}') $*
}

function logsFromPod {
  pod=$(getPod $1)
  shift
  kubectl logs -f $(echo $pod|awk '{print $2}') --namespace=$(echo $pod | awk '{print $1}') $*
}

function create {
  kubectl create -f $1
}

function delete {
  kubectl delete -f $1
}

function apply {
  kubectl apply -f $1
}

alias ke='execInPod'
alias kl='logsFromPod'
alias kgp='kubectl get pods --all-namespaces'
alias kc='create'
alias kd='delete'
alias ka='apply'
