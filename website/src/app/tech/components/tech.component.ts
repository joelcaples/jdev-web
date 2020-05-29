import { Component, OnInit } from '@angular/core';
import { TechDataService } from '../services/tech-data.service';
import { Section } from '../models/tech.model';

@Component({
  selector: 'app-tech',
  templateUrl: './tech.component.html',
  styleUrls: ['./tech.component.scss']
})
export class TechComponent implements OnInit {

  public sections:Section[];

  constructor(private techDataService:TechDataService) { }

  ngOnInit(): void {
    this.techDataService.getTechData()
    .subscribe(results => {
        this.sections = results.Sections;
        console.log(this.sections);
      });
  }

}
