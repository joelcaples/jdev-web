import { Component, OnInit } from '@angular/core';
import { WebRequestService } from 'src/app/services/web-request.service';
import { HttpClient } from '@angular/common/http';
import { WebResponse } from 'src/models/web-response.model';

@Component({
  selector: 'web-scraper',
  templateUrl: './web-scraper.component.html',
  styleUrls: ['./web-scraper.component.scss']
})
export class WebScraperComponent implements OnInit {

  public responses:WebResponse[]=[];

  constructor(private webRequestService:WebRequestService, public http: HttpClient) { }

  ngOnInit(): void {
  }

  public go() {
    this.responses=[];
    this.GetWebRequestsSerial();
  }

  public async GetWebRequestsSerial() {
    for (let i:number=0;i<100;++i) {
      let startTime=new Date();
      let result = await this.WebRequestPromise(); 
      this.responses.push(<WebResponse>({Value:result, StartTime:startTime, EndTime:new Date()}));
    }
  }

  public WebRequestPromise():Promise<string> {
    return new Promise(resolve => {
      setTimeout(() => {
        resolve(
          this.webRequestService.makeRequest()
          .toPromise()          
        );
      }, 1000);      
    });
  }

}
