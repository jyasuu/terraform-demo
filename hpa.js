import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  stages: [
    { duration: '1m', target: 100 }, // Ramp-up to 100 VUs
    { duration: '3m', target: 100 }, // Sustain load
    { duration: '1m', target: 0 },   // Ramp-down
  ],
};
// kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
// kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
// kubectl port-forward svc/hpa-demo 8080:80 -n hpa-demo 
// watch -n 1 "kubectl get hpa -n hpa-demo  && kubectl get pods -n hpa-demo"
export default function () {
  const res = http.get('http://localhost:8080');
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}