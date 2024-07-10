import { delay } from 'rxjs/operators';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../../environments/environment';
import { HttpClient } from '@angular/common/http';

@Injectable()
export class BranchInfoService {

  constructor(private httpClient: HttpClient) {
  }

  getBranchInfo(id): Observable<any> {
    return this.httpClient.get(
      `${environment.API_ENDPOINT}branches/${id}`)
      .pipe(delay(environment.RESPONSE_DELAY));
  }
}
