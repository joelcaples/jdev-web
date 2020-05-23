import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './modules/app-routing/app-routing.module';
import { AppComponent } from './app.component';
import { RequestQueueComponent } from './widgets/request-queue/request-queue.component';
import { WebScraperComponent } from './widgets/web-scraper/web-scraper.component';
import { HttpClientModule } from '@angular/common/http';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { TechComponent } from './components/tech/tech.component';
import { ResourcesComponent } from './components/resources/resources.component';
import { WidgetDashboardComponent } from './widgets/widget-dashboard/widget-dashboard.component';
import { ComicsComponent } from './components/comics/comics.component';
import { FormsModule } from '@angular/forms';
import { AgGridModule } from 'ag-grid-angular';

@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent,
    WebScraperComponent,
    TechComponent,
    ResourcesComponent,
    WidgetDashboardComponent,
    ComicsComponent
  ],
  imports: [
    FormsModule,
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    NgbModule,
    AgGridModule.withComponents([])
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
