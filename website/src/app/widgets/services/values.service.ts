import { Injectable } from '@angular/core';
import { Values } from 'src/app/widgets/models/values.model';

@Injectable({
  providedIn: 'root'
})
export class ValuesService {

  constructor() { }

  public calculate(value:number):Values {
    return <Values>({
      Value:value,
      ValueSqrt:Math.sqrt(value),
      ValueSqared:Math.pow(value, 2),
      ValueCubed:Math.pow(value, 3)
    });
  }

}
