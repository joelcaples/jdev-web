import { Component, OnInit } from '@angular/core';
import { Values } from 'src/app/widgets/models/values.model';
import { ValuesService } from 'src/app/widgets/services/values.service';

@Component({
  selector: 'request-queue',
  templateUrl: './request-queue.component.html',
  styleUrls: ['./request-queue.component.scss']
})
export class RequestQueueComponent implements OnInit {

  public values:Values[] = [];

  constructor(private valuesSerivice:ValuesService) { }

  ngOnInit(): void {
  }

  public go() {
    this.values=[];
    this.GetValuesSerial();
  }

  public async GetValuesSerial() {
    let finalResult = 0;
    for (let i:number=0;i<100;++i) {
      let result = await this.ValuesPromise(i,1); 
      this.values.push(result);
    }
  }

  public ValuesPromise(x:number, sec:number):Promise<Values> {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve(this.valuesSerivice.calculate(x));
      }, sec *1000);
    });
  }
}
