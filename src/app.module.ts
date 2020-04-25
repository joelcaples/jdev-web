import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app/modules/app-routing/app-routing.module';
import { AppComponent } from './app/components/app/app.component';
import { RequestQueueComponent } from './app/components/request-queue/request-queue.component';
import { WebScraperComponent } from './app/components/web-scraper/web-scraper.component';
import { HttpClientModule } from '@angular/common/http';
import { HeaderComponent } from './app/components/header/header.component';
import { PortletComponent } from './app/components/portlet/portlet.component';

@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent,
    WebScraperComponent,
    HeaderComponent,
    PortletComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
