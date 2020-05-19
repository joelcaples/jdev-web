import { Component, OnInit } from '@angular/core';
import { TechDataService } from 'src/app/services/tech-data.service';
import { Section } from 'src/app/models/tech.model';

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
