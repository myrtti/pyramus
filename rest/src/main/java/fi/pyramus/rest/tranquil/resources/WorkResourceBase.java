package fi.pyramus.rest.tranquil.resources;

import fi.tranquil.TranquilModel;
import fi.tranquil.TranquilModelType;

@TranquilModel (entityClass = fi.pyramus.domainmodel.resources.WorkResource.class, entityType = TranquilModelType.BASE)
public class WorkResourceBase implements fi.tranquil.TranquilModelEntity {

  public Long getId() {
    return id;
  }

  public void setId(Long id) {
    this.id = id;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public Boolean getArchived() {
    return archived;
  }

  public void setArchived(Boolean archived) {
    this.archived = archived;
  }

  public java.util.Set<fi.pyramus.domainmodel.base.Tag> getTags() {
    return tags;
  }

  public void setTags(java.util.Set<fi.pyramus.domainmodel.base.Tag> tags) {
    this.tags = tags;
  }

  public fi.pyramus.domainmodel.resources.ResourceType getResourceType() {
    return resourceType;
  }

  public void setResourceType(fi.pyramus.domainmodel.resources.ResourceType resourceType) {
    this.resourceType = resourceType;
  }

  public String getNameSortable() {
    return nameSortable;
  }

  public void setNameSortable(String nameSortable) {
    this.nameSortable = nameSortable;
  }

  public Long getVersion() {
    return version;
  }

  public void setVersion(Long version) {
    this.version = version;
  }

  public fi.pyramus.persistence.usertypes.MonetaryAmount getHourlyCost() {
    return hourlyCost;
  }

  public void setHourlyCost(fi.pyramus.persistence.usertypes.MonetaryAmount hourlyCost) {
    this.hourlyCost = hourlyCost;
  }

  public fi.pyramus.persistence.usertypes.MonetaryAmount getCostPerUse() {
    return costPerUse;
  }

  public void setCostPerUse(fi.pyramus.persistence.usertypes.MonetaryAmount costPerUse) {
    this.costPerUse = costPerUse;
  }

  private Long id;

  private String name;

  private Boolean archived;

  private java.util.Set<fi.pyramus.domainmodel.base.Tag> tags;

  private fi.pyramus.domainmodel.resources.ResourceType resourceType;

  private String nameSortable;

  private Long version;

  private fi.pyramus.persistence.usertypes.MonetaryAmount hourlyCost;

  private fi.pyramus.persistence.usertypes.MonetaryAmount costPerUse;

  public final static String[] properties = {"id","name","archived","tags","resourceType","nameSortable","version","hourlyCost","costPerUse"};
}