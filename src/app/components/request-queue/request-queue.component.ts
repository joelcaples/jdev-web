import { Component, OnInit } from '@angular/core';
import { Values } from 'src/models/values.model';
import { ValuesService } from 'src/app/services/values.service';

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
    this.values = [];
    for(let i:number = 0;i<100;++i) {
      this.values.push(this.valuesSerivice.calculate(i));
    }
  }

}
