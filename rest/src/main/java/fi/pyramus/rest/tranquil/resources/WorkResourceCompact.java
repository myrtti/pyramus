package fi.pyramus.rest.tranquil.resources;

import fi.tranquil.TranquilModel;
import fi.tranquil.TranquilModelType;

@TranquilModel  (entityClass = fi.pyramus.domainmodel.resources.WorkResource.class, entityType = TranquilModelType.COMPACT)
public class WorkResourceCompact extends WorkResourceBase {

  public Long getCategory_id() {
    return category_id;
  }

  public void setCategory_id(Long category_id) {
    this.category_id = category_id;
  }

  private Long category_id;

  public final static String[] properties = {"category"};
}