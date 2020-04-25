import { Component, OnInit } from '@angular/core';
import { WebRequestService } from 'src/app/services/web-request.service';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'web-scraper',
  templateUrl: './web-scraper.component.html',
  styleUrls: ['./web-scraper.component.scss']
})
export class WebScraperComponent implements OnInit {

  public results:string[]=[];

  constructor(private webRequestService:WebRequestService, public http: HttpClient) { }

  ngOnInit(): void {
  }

  public go() {
    this.results=[];
    this.GetWebRequestsSerial();
  }

  public async GetWebRequestsSerial() {
    for (let i:number=0;i<100;++i) {
      let result = await this.WebRequestPromise(); 
      this.results.push(result);
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
