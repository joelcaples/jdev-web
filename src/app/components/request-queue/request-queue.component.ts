import { Component, OnInit } from '@angular/core';
import { Values } from 'src/models/values.model';

@Component({
  selector: 'request-queue',
  templateUrl: './request-queue.component.html',
  styleUrls: ['./request-queue.component.scss']
})
export class RequestQueueComponent implements OnInit {

  private values:Values[] = [];

  constructor() { }

  ngOnInit(): void {
  }

  public go() {
    this.values = [];
    for(let i:number = 0;i<100;++i) {
      this.values.push(this.calculate(i));
    }
  }

  public calculate(value:number):Values {
    return <Values>({
      Value:value,
      ValueSqrt:Math.sqrt(value),
      ValueSqared:Math.pow(value, 2),
      ValueCubed:Math.pow(value, 3)
    });
  }
}
