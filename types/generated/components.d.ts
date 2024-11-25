import type { Schema, Struct } from '@strapi/strapi';

export interface CarouselCarousel extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousels';
  info: {
    description: '';
    displayName: 'Carousel';
    icon: 'slideshow';
  };
  attributes: {
    CarouselItems: Schema.Attribute.Component<'carousel.carousel-item', true>;
    CarouselSlider: Schema.Attribute.Component<'carousel.carousel-text', true>;
    Title: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

export interface CarouselCarouselItem extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousel_items';
  info: {
    displayName: 'CarouselItem';
    icon: 'bulletList';
  };
  attributes: {
    Description: Schema.Attribute.Text & Schema.Attribute.Required;
    Image: Schema.Attribute.Media<'images' | 'files'> &
      Schema.Attribute.Required;
    Title: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

export interface CarouselCarouselText extends Struct.ComponentSchema {
  collectionName: 'components_carousel_carousel_texts';
  info: {
    description: '';
    displayName: 'CarouselText';
    icon: 'pencil';
  };
  attributes: {
    Text: Schema.Attribute.Text & Schema.Attribute.Required;
  };
}

export interface CustomHero extends Struct.ComponentSchema {
  collectionName: 'components_custom_heroes';
  info: {
    displayName: 'Hero';
    icon: 'picture';
  };
  attributes: {
    BackgroundImage: Schema.Attribute.Media<'images' | 'files'> &
      Schema.Attribute.Required;
    MainImage: Schema.Attribute.Media<'images' | 'files'>;
    Name: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

export interface NavigationNavigationItem extends Struct.ComponentSchema {
  collectionName: 'components_navigation_navigation_items';
  info: {
    displayName: 'NavigationItem';
    icon: 'link';
  };
  attributes: {
    Name: Schema.Attribute.String & Schema.Attribute.Required;
    URL: Schema.Attribute.String & Schema.Attribute.Required;
  };
}

declare module '@strapi/strapi' {
  export module Public {
    export interface ComponentSchemas {
      'carousel.carousel': CarouselCarousel;
      'carousel.carousel-item': CarouselCarouselItem;
      'carousel.carousel-text': CarouselCarouselText;
      'custom.hero': CustomHero;
      'navigation.navigation-item': NavigationNavigationItem;
    }
  }
}
