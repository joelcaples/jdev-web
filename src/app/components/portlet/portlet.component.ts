import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-portlet',
  templateUrl: './portlet.component.html',
  styleUrls: ['./portlet.component.scss']
})
export class PortletComponent implements OnInit {

  public mode:string="BLANK";
  public asOfDate:Date=new Date();

  constructor() { }

  ngOnInit(): void {
  }

}
